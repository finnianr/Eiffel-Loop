note
	description: "[
		Inherit this class from the root class of your application to configure logging output.
		Call init_logging to configure the logging
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 17:48:24 GMT (Friday 8th July 2016)"
	revision: "4"

deferred class
	EL_LOGGED_APPLICATION

inherit
	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_ARGS

feature -- Status query

	is_logging_initialized: BOOLEAN

feature {NONE} -- Implementation

	init_logging (a_log_filters: like log_filter_array; output_directory: EL_DIR_PATH)
			--
		do
			log_manager.set_output_directory (output_directory)
			log_manager.initialize
			if logging.is_active then
				logging.set_routines_to_log (a_log_filters)
			else
				if log_manager.is_console_manager_active then
					io.put_string ("Thread logging disabled")
					io.put_new_line
				end
			end

			log_manager.add_thread (new_identified_main_thread)

			is_logging_initialized := true
		end

	log_filter_array: ARRAY [EL_LOG_FILTER]
			--
		local
			l_log_filter: like log_filter
		do
			l_log_filter := log_filter
			create Result.make (1, l_log_filter.count)
			across l_log_filter as l_tuple loop
				Result [l_tuple.cursor_index] := create {EL_LOG_FILTER}.make (l_tuple.item.class_type, l_tuple.item.routines)
			end
		end

	log_filter: ARRAY [like Type_logging_filter]
			--
		deferred
		end

	new_identified_main_thread: EL_IDENTIFIED_MAIN_THREAD
		do
			create Result.make ("Main")
		end

feature {NONE} -- Type definitions

	Type_logging_filter: TUPLE [class_type: TYPE [EL_MODULE_LOG]; routines: STRING]
		once
		end

feature {NONE} -- Constants

	All_routines: STRING = "*"

	No_routines: STRING = "-*"

end