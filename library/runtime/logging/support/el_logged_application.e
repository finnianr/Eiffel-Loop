note
	description: "[
		Inherit this class from the root class of your application to configure logging output.
		Call init_logging to configure the logging
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_LOGGED_APPLICATION

inherit
	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_ARGS

	EL_LOG_CONSTANTS
		rename
			implementation as implementation_log_constants
		end

feature -- Status query

	is_logging_initialized: BOOLEAN

feature {NONE} -- Implementation

	init_logging (is_logging_active: BOOLEAN; a_log_filters: like log_filter_array)
			--
		do
			log_manager.initialize
			if is_logging_active then
				logging.activate
				logging.set_routines_to_log (a_log_filters)
			else
				if log_manager.is_console_manager_active then
					io.put_string ("Thread logging disabled")
					io.put_new_line
				end
			end

			log_manager.add_visible_thread (create {EL_IDENTIFIED_MAIN_THREAD}, "Main")

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

feature {NONE} -- Type definitions

	Type_logging_filter: TUPLE [class_type: TYPE [EL_MODULE_LOG]; routines: STRING]
		once
		end
end
