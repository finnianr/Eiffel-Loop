note
	description: "Summary description for {EL_LOG_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-25 12:34:19 GMT (Saturday 25th January 2014)"
	revision: "4"

class
	EL_LOG_MANAGER

inherit
	EL_MODULE_LOGGING

	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM
		export
			{NONE} all
		end

	EL_MODULE_ARGS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	 make
			--
		do
			make_thread_access

			create log_file_by_thread_id_table.make (11)
			create log_file_by_object_id_table.make (11)
			create thread_id_list.make (11)
			is_highlighting_enabled := not (Args.word_option_exists ("no_highlighting") or {PLATFORM}.is_windows)
		end

feature -- Initialization

	initialize
			--
		do
			delete_logs
			create thread_registration_consumer.make
			thread_registration_consumer.disable_logging

			create thread_registration_queue.make
			thread_registration_queue.attach_consumer (thread_registration_consumer)
		end

feature {EL_CONSOLE_MANAGER} -- Access

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

	thread_registration_consumer: EL_TUPLE_CONSUMER_MAIN_THREAD [EL_CONSOLE_MANAGER, TUPLE [STRING]]

feature -- Access

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

	current_thread_log_path: EL_FILE_PATH
			--
		require
			logging_is_active: logging.is_active
		do
			create Result.make_from_path (current_thread_log_file.path)
		end

feature {EL_LOG} -- Access

	current_thread_log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		--	 Log file for calling thread
		do
			restrict_access
			Result := thread_log_file ({THREAD_ENVIRONMENT}.current_thread_id)

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

	add_visible_thread (thread: EL_IDENTIFIED_THREAD_I; name: STRING)
			--	make thread output visible in console
		local
			log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			if logging.is_active then
				restrict_access
				log_file_by_object_id_table.search (thread.object_id)

				if log_file_by_object_id_table.found then
					log_file := log_file_by_object_id_table.found_item
					thread_id_list.put_i_th (thread.thread_id, log_file.index)

					log_file_by_thread_id_table.force (log_file, thread.thread_id)
				else
					thread_id_list.extend (thread.thread_id)
					if thread_id_list.count = 1 then
						thread_id_list.start
					end
					if is_highlighting_enabled then
						create {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} log_file.make (
							log_file_path (name), name, thread_id_list.count
						)
					else
						create log_file.make (log_file_path (name), name, thread_id_list.count)
					end
					log_file_by_thread_id_table [thread.thread_id] := log_file
					log_file_by_object_id_table [thread.object_id] := log_file

					thread_registration_queue.put ([name])

				end
				end_restriction
			end
		end

feature -- Status query

	no_thread_logs_created: BOOLEAN
			--
		do
			restrict_access
			Result := log_file_by_thread_id_table.is_empty

			end_restriction
		end

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

	is_highlighting_enabled: BOOLEAN
		-- Can terminal color highlighting sequences be output to console

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
			valid_index: logging.is_active implies is_valid_console_index (index)
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

	flush_current_thread_log
			--
		local
			log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			log_file := current_thread_log_file
			log_file.flush_file
		end

	close_logs
			-- Call only when all threads are joined
		do
			restrict_access
			from log_file_by_thread_id_table.start until log_file_by_thread_id_table.after loop
				log_file_by_thread_id_table.item_for_iteration.close
				log_file_by_thread_id_table.forth
			end
			end_restriction
		end

feature -- Removal

	delete_logs
			--
		local
			log_directory: DIRECTORY
		do
			if Location_path.exists then
				create log_directory.make_with_name (Location_path.unicode)
				log_directory.delete_content
			end
		end

feature {NONE} -- Implementation

	log_file_path (name: EL_ASTRING): EL_FILE_PATH
			--
		local
			count: INTEGER
			is_available_path: BOOLEAN
			combined_extension: EL_ASTRING
		do
			if not Location_path.exists then
				File_system.make_directory (Location_path)
			end

			Result := Location_path + name

			from until is_available_path loop
				count := count + 1
				combined_extension := Count_format.formatted (count)
				combined_extension.append_character ('.')
				combined_extension.append (Default_log_file_extension)
				Result.add_extension (combined_extension)
				if Result.exists then
					Result.base.remove_tail (combined_extension.count + 1)
				else
					is_available_path := True
				end
			end
		end

	thread_log_file (thread_id: POINTER): EL_FILE_AND_CONSOLE_LOG_OUTPUT
		--	
		do
			Result := log_file_by_thread_id_table [thread_id]
		end

	thread_name (thread_id: POINTER): STRING
		--	
		do
			Result := thread_log_file (thread_id).thread_name
		end

	log_file_by_thread_id_table: HASH_TABLE [EL_FILE_AND_CONSOLE_LOG_OUTPUT, POINTER]

	log_file_by_object_id_table: HASH_TABLE [EL_FILE_AND_CONSOLE_LOG_OUTPUT, INTEGER]

	thread_id_list: ARRAYED_LIST [POINTER]

	thread_registration_queue: EL_THREAD_PRODUCT_QUEUE [TUPLE [STRING]]

	console_manager_active: BOOLEAN

feature {NONE} -- Constants

	Location_path: EL_DIR_PATH
			--
		once ("PROCESS")
			Result := Environment.Operating.Temp_directory_path.twin
			Result.append_file_path (Environment.Execution.executable_name + "-logs")
		end

	Default_log_file_extension: STRING = "log"

	Count_format: FORMAT_INTEGER
			--
		once
			create Result.make (3)
			Result.zero_fill
		end

end
