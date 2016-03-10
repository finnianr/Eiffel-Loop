note
	description: "Default 'do nothing' log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-03 10:50:59 GMT (Sunday 3rd May 2015)"
	revision: "4"

class
	EL_LOG

inherit
	EL_MODULE_LOG_MANAGER
		export
			{NONE} all
		end

	EL_MODULE_LOGGING
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL
		export
			{NONE} all
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
		end

feature {EL_CONSOLE_LOG, EL_MODULE_LOG} -- Element change

	set_logged_object (current_logged_object: ANY)
			--
		do
		end

	set_timer
			-- Set routine timer to now
		do
		end

	restore (previous_stack_count: INTEGER)
			--
		do
		end

feature -- Query

	call_stack_count: INTEGER
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
			Result := traced_routine_call_stack.count
		end

feature -- Output

	enter (routine_name: STRING )
			-- Enter start of routine
		do
		end

	enter_with_args (routine_name: STRING; arg_objects: ARRAY [ANY])
			--
		do
		end

	enter_no_header (routine_name: STRING)
			--
		do
		end

	exit_no_trailer
		do
		end

	exit
		do
		end

	put_configuration_info (a_log_filters: ARRAY [EL_LOG_FILTER])
		do
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		do
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		do
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		do
		end

	put_integer (i: INTEGER)
			--
		do
		end

	put_character (c: CHARACTER)
			--
		do
		end

	put_real (r: REAL)
			--
		do
		end

	put_boolean (b: BOOLEAN)
			--
		do
		end

	put_double (d: DOUBLE)
			--
		do
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		do
		end

	put_string_field_to_max_length (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		do
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		do
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		do
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		do
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		do
		end

	put_new_line
			--
		do
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		do
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
			--
		do
		end

feature -- Input

	pause_for_enter_key
		do
		end

feature {NONE} -- Implementation

	current_routine: like Logging.type_routine_info
			--
		require
			valid_logged_routine_call_stack: not Traced_routine_call_stack.is_empty
		do
			Result := traced_routine_call_stack.item
		end

	traced_routine_call_stack: ARRAYED_STACK [like Logging.type_routine_info]
		do
			create Result.make (0)
		end

end
