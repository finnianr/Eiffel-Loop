note
	description: "Silent 'do nothing' log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-14 11:31:58 GMT (Thursday 14th June 2018)"
	revision: "6"

class
	EL_SILENT_LOG

inherit
	EL_LOGGABLE

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
		end

feature {EL_CONSOLE_ONLY_LOG} -- Element change

	restore (previous_stack_count: INTEGER)
			--
		do
		end

	set_logged_object (current_logged_object: ANY)
			--
		do
		end

	set_timer
			-- Set routine timer to now
		do
		end

feature -- Input

	pause_for_enter_key
		do
		end

feature -- Status change

	tab_left
			--
		do
		end

	tab_right
			--
		do
		end

feature -- Output

	enter (routine_name: STRING )
			-- Enter start of routine
		do
		end

	enter_no_header (routine_name: STRING)
			--
		do
		end

	enter_with_args (routine_name: STRING; arg_objects: ARRAY [ANY])
			--
		do
		end

	exit
		do
		end

	exit_no_trailer
		do
		end

	put_boolean (b: BOOLEAN)
			--
		do
		end

	put_character (c: CHARACTER)
			--
		do
		end

	put_configuration_info (log_filters: ARRAYED_LIST [EL_LOG_FILTER])
		do
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		do
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		do
		end

	put_labeled_substitution (lable, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		do
		end

	put_new_line
			--
		do
		end

	put_new_line_x2
		do
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
			--
		do
		end

	put_string (s: READABLE_STRING_GENERAL)
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

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
		end

feature -- Numeric output

	put_double (d: DOUBLE)
			--
		do
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		do
		end


	put_integer (i: INTEGER)
			--
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

	put_real (r: REAL)
			--
		do
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		do
		end

end
