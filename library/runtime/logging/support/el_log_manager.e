note
	description: "Log manager"
	descendants: "[
			EL_LOG_MANAGER
				${EL_CRC_32_LOG_MANAGER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-15 12:42:46 GMT (Monday 15th July 2024)"
	revision: "23"

class
	EL_LOG_MANAGER

inherit
	EL_STRING_GENERAL_ROUTINES

	EL_MODULE_LOGGING

	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_ARGS; EL_MODULE_CONSOLE; EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM

	EL_SHARED_DIRECTORY
		rename
			directory as shared_directory
		end

	EL_SHARED_LOG_OPTION

	EL_SOLITARY
		rename
			make as make_solitary
		end

create
	make

feature {NONE} -- Initialization

	 make (logging_active: BOOLEAN; a_output_directory: DIR_PATH)
			--
		do
			make_solitary; make_default

			is_logging_active := logging_active
			output_directory := a_output_directory
			create log_file_by_thread_id_table.make (11)
			create log_file_by_object_id_table.make (11)
			create thread_id_list.make (11)
			console_manager_active := Log_option.thread_toolbar
		end

feature -- Initialization

	initialize
			--
		do
			create thread_registration_consumer.make

			create thread_registration_queue.make (10)
			thread_registration_queue.attach_consumer (thread_registration_consumer)
		end

feature -- Access

	current_thread_log_path: FILE_PATH
			--
		require
			logging_is_active: is_logging_active
		do
			create Result.make_from_path (current_thread_log_file.path)
		end

	output_directory_path: DIR_PATH
		do
			restrict_access
			Result := output_directory.twin
			end_restriction
		end

	thread_index (name: STRING): INTEGER
			--
		do
			restrict_access
			from
				thread_id_list.start
			until
				thread_name (thread_id_list.item) ~ name or thread_id_list.after
			loop
				thread_id_list.forth
			end
			if not thread_id_list.after then
				Result := thread_id_list.index
			end
			end_restriction
		end

feature -- Element change

	activate_console_manager
			--
		do
			restrict_access
			console_manager_active := true

			end_restriction
		end

	add_thread (thread: EL_IDENTIFIED_THREAD_I)
			--	make thread output visible in console
		local
			log_file: like new_log_file
		do
			if logging.is_active then
				restrict_access
					if log_file_by_object_id_table.has_key (thread.object_id) then
						log_file := log_file_by_object_id_table.found_item
						thread_id_list.put_i_th (thread.thread_id, log_file.index)

						log_file_by_thread_id_table.force (log_file, thread.thread_id)
					else
						thread_id_list.extend (thread.thread_id)
						if thread_id_list.count = 1 then
							thread_id_list.start
						end
						log_file := new_log_file (thread)
						log_file_by_thread_id_table [thread.thread_id] := log_file
						log_file_by_object_id_table [thread.object_id] := log_file

						thread_registration_queue.put ([thread])
					end
				end_restriction
			end
		end

feature -- Status query

	is_console_manager_active: BOOLEAN
			--
		do
			restrict_access
			Result := console_manager_active

			end_restriction
		end

	is_valid_console_index (index: INTEGER): BOOLEAN
			--
		do
			restrict_access
			Result := index >=1 and index <= thread_id_list.count

			end_restriction
		end

	is_logging_active: BOOLEAN

	no_thread_logs_created: BOOLEAN
			--
		do
			restrict_access
			Result := log_file_by_thread_id_table.is_empty

			end_restriction
		end

feature -- Basic operations

	redirect_main_thread_to_console
			-- set output of main thread to console
		do
			redirect_thread_to_console (1)
		end

	redirect_thread_to_console (index: INTEGER)
		--	Activate a thread's logging output to console
		-- (Only one thread can be active at a time)
		require
			valid_index: is_logging_active implies is_valid_console_index (index)
		local
			log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			restrict_access
			if logging.is_active and then thread_id_list.index /= index then
				log_file := log_file_by_thread_id_table [thread_id_list.item]
				log_file.stop_console

				thread_id_list.go_i_th (index)
				log_file := log_file_by_thread_id_table [thread_id_list.item]
				log_file.redirect_to_console
			end

			end_restriction
		end

	redirect_output_to_console (thread: EL_IDENTIFIED_THREAD_I)
		local
			thread_id: POINTER
		do
			thread_id := thread.thread_id
			restrict_access
			if logging.is_active and then thread_id_list.item /= thread_id
				and then log_file_by_thread_id_table.has (thread_id)
			then
				log_file_by_thread_id_table.item (thread_id_list.item).stop_console
				thread_id_list.start; thread_id_list.search (thread_id)
				check
					found_thread: not thread_id_list.exhausted
				end
				log_file_by_thread_id_table.item (thread_id_list.item).redirect_to_console
			end
			end_restriction
		end

feature -- Status setting

	clear_current_thread_log
			--
		local
			log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			log_file := current_thread_log_file
			log_file.close
			log_file.wipe_out
			log_file.open_write
		end

	close_logs
			-- Call only when all threads are joined
		do
			restrict_access
			across log_file_by_thread_id_table as log_file loop
				log_file.item.close
			end
			end_restriction
		end

	flush_current_thread_log
			--
		local
			log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			log_file := current_thread_log_file
			log_file.flush_file
		end

feature -- Removal

	delete_logs
			--
		do
			if output_directory.exists then
				Shared_directory.named (output_directory).delete_content
			end
		end

feature {EL_CONSOLE_MANAGER, EL_LOGGABLE, EL_MODULE_LOG_MANAGER} -- Access

	console_thread_index: INTEGER
		--	 Index number of thread currently directed to console
		do
			restrict_access
			Result := thread_id_list.index

			end_restriction
		end

	console_thread_log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		--	 Log file of thread currently directed to console
		do
			restrict_access
			Result := thread_log_file (thread_id_list.item)

			end_restriction
		end

	current_thread_log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		--	 Log file for calling thread
		do
			restrict_access
			Result := thread_log_file ({THREAD_ENVIRONMENT}.current_thread_id)

			end_restriction
		end

	thread_registration_consumer: EL_ACTION_ARGUMENTS_CONSUMER_MAIN_THREAD [TUPLE [EL_IDENTIFIED_THREAD_I]]

feature {EL_LOG_PRUNE_COMMAND} -- Factory

	new_log_file (thread: EL_IDENTIFIED_THREAD_I): EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				Result := new_highlighted_output (new_log_file_path (thread.name), thread.name, thread_id_list.count)
			else
				Result := new_output (new_log_file_path (thread.name), thread.name, thread_id_list.count)
			end
		end

	new_log_file_path (name: READABLE_STRING_GENERAL): FILE_PATH
			--
		local
			version_path: FILE_PATH; log_path_list: EL_FILE_PATH_LIST
			version_base: ZSTRING
		do
			version_base := as_zstring (name) + ".000." + Default_log_file_extension
			if output_directory.exists then
				log_path_list := File_system.files_with_extension (
					output_directory_path, Default_log_file_extension, False
				)
				log_path_list.sort (False) -- reverse
				log_path_list.find_first_true (agent is_named (?, name))
				if log_path_list.found then
					version_path := log_path_list.path
				else
					version_path := output_directory + version_base
				end
			else
				File_system.make_directory (output_directory)
				version_path := output_directory + version_base
			end
			Result := version_path.next_version_path
		end

	new_log_path_list (name: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [FILE_PATH]
		local
			log_path_list: EL_FILE_PATH_LIST
		do
			log_path_list := File_system.files_with_extension (
				output_directory_path, Default_log_file_extension, False
			)
			log_path_list.sort (False)
			Result := log_path_list.query_if (agent is_named (?, name))
		end

	new_highlighted_output (log_path: FILE_PATH; a_thread_name: READABLE_STRING_GENERAL; a_index: INTEGER): like new_log_file
		do
			create {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

	new_output (log_path: FILE_PATH; a_thread_name: READABLE_STRING_GENERAL; a_index: INTEGER): like new_log_file
		do
			create Result.make (log_path, a_thread_name, a_index)
		end

feature {NONE} -- Implementation

	is_named (log_path: FILE_PATH; name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached log_path.base as base and then base.starts_with_general (name) then
				Result := base [name.count + 1] = '.'
			end
		end

	thread_log_file (thread_id: POINTER): EL_FILE_AND_CONSOLE_LOG_OUTPUT
		--	
		do
			Result := log_file_by_thread_id_table [thread_id]
		end

	thread_name (thread_id: POINTER): ZSTRING
		--	
		do
			Result := thread_log_file (thread_id).thread_name
		end

feature {NONE} -- Internal attributes

	console_manager_active: BOOLEAN

	log_file_by_object_id_table: HASH_TABLE [EL_FILE_AND_CONSOLE_LOG_OUTPUT, INTEGER]

	log_file_by_thread_id_table: HASH_TABLE [EL_FILE_AND_CONSOLE_LOG_OUTPUT, POINTER]

	output_directory: DIR_PATH

	thread_id_list: ARRAYED_LIST [POINTER]

	thread_registration_queue: EL_THREAD_PRODUCT_QUEUE [TUPLE [EL_IDENTIFIED_THREAD_I]]

feature {NONE} -- Constants

	Default_log_file_extension: STRING = "log"

end