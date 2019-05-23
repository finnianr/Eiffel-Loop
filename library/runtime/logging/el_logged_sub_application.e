note
	description: "Logged sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-05 8:51:42 GMT (Sunday 5th May 2019)"
	revision: "5"

deferred class
	EL_LOGGED_SUB_APPLICATION

inherit
	EL_SUB_APPLICATION
		rename
			init_console as init_console_and_logging
		undefine
			new_lio
		redefine
			do_application, init_console_and_logging, io_put_header, standard_options
		end

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

feature -- Status query

	is_logging_initialized: BOOLEAN

feature {NONE} -- Implementation

	do_application
		local
			log_stack_pos: INTEGER; ctrl_c_pressed, other_exception: BOOLEAN
		do
			if ctrl_c_pressed then
				on_operating_system_signal

			elseif other_exception then
				on_exception
			else
				log.enter ("make")
				log_stack_pos := log.call_stack_count
				Precursor
			end
			log.exit
			Log_manager.close_logs

			if not other_exception then
				Log_manager.delete_logs
			end
		rescue
			if Exception.last.is_signal then
				ctrl_c_pressed := True
			else
				other_exception := True
			end
			log.restore (log_stack_pos)
			retry -- for normal exit
		end

	io_put_header
		do
			log.enter_no_header ("io_put_header")
			Precursor
			log.exit_no_trailer
			log.put_configuration_info (Log_filter_list.item (Current))
			if not Logging.is_active then
				lio.put_new_line_x2
			end
		end

	init_console_and_logging
			--
		do
			Precursor
			Log_manager.set_output_directory (Log_output_directory)
			Log_manager.initialize

			if logging.is_active then
				logging.set_routines_to_log (Log_filter_list.item (Current))
			else
				if Log_manager.is_console_manager_active then
					lio.put_string ("Thread logging disabled")
				end
			end
			Log_manager.add_thread (new_identified_main_thread)
			is_logging_initialized := true
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		deferred
		end

	on_exception
		do
			Exception.put_last_trace (log)
		end

	standard_options: EL_HASH_TABLE [STRING, STRING]
		do
			Result := Precursor
			Result [{EL_LOG_COMMAND_OPTIONS}.Logging] := "Activate application logging to console"
			Result [{EL_LOG_COMMAND_OPTIONS}.Keep_logs] := "Do not delete log file on program exit"
		end

feature {EL_LOGGED_SUB_APPLICATION} -- Factory

	new_log_filter_list: ARRAYED_LIST [EL_LOG_FILTER]
			--
		local
			filters: like log_filter
		do
			filters := log_filter
			create Result.make (filters.count)
			Result.compare_objects
			across filters as tuple loop
				Result.extend (new_log_filter (tuple.item.class_type, tuple.item.routines))
			end
		end

	new_identified_main_thread: EL_IDENTIFIED_MAIN_THREAD
		do
			create Result.make ("Main")
		end

	new_log_filter (class_type: TYPE [EL_MODULE_LOG]; a_routines: STRING): EL_LOG_FILTER
		do
			create Result.make (class_type, a_routines)
		end

feature {NONE} -- Type definitions

	CLASS_ROUTINES: TUPLE [class_type: TYPE [EL_MODULE_LOG]; routines: STRING]
		once
			Result := [{like Current}, ""]
		end

feature {NONE} -- Constants

	All_routines: STRING = "*"

	Log_filter_list: EL_FUNCTION_RESULT_TABLE [EL_LOGGED_SUB_APPLICATION, ARRAYED_LIST [EL_LOG_FILTER]]
			--
		once
			create Result.make (11, agent {EL_LOGGED_SUB_APPLICATION}.new_log_filter_list)
		end

	Log_output_directory: EL_DIR_PATH
		once
			Result := Directory.App_data.joined_dir_tuple ([option_name, "logs"])
		end

	No_routines: STRING = "-*"

end
