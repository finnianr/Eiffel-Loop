note
	description: "[
		Inherit this class from the root class of your application to configure logging output.
		Call init_logging to configure the logging
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 14:37:31 GMT (Thursday 29th June 2017)"
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

	init_logging (a_log_filters: like log_filter_list; output_directory: EL_DIR_PATH)
			--
		do
			Log_manager.set_output_directory (output_directory)
			Log_manager.initialize

			if logging.is_active then
				logging.set_routines_to_log (a_log_filters)
			else
				if Log_manager.is_console_manager_active then
					lio.put_string ("Thread logging disabled")
				end
			end
			Log_manager.add_thread (new_identified_main_thread)
			is_logging_initialized := true
		end

	log_filter_list: ARRAYED_LIST [EL_LOG_FILTER]
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

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		deferred
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

	No_routines: STRING = "-*"

end
