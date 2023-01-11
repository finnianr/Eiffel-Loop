note
	description: "Loggable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-11 8:08:47 GMT (Wednesday 11th January 2023)"
	revision: "23"

deferred class
	EL_LOGGABLE

inherit
	ANY

	EL_SHARED_CONSOLE_COLORS

feature {NONE} -- Initialization

	make_default
		do
			routine_call_stack := Empty_routine_call_stack
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		deferred
		end

feature -- Type definitions

	NAME_VALUE_PAIR: TUPLE [name: READABLE_STRING_GENERAL; value: ANY]
		once
			create Result
		end

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LIO} -- Basic operations

	clear
		-- clear screen		
		deferred
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		deferred
		end

	restore (previous_stack_count: INTEGER)
			--
		deferred
		end

	set_logged_object (current_logged_object: ANY)
			--
		deferred
		end

	set_timer
			-- Set routine timer to now
		deferred
		end

feature -- Measurement

	call_stack_count: INTEGER
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
			Result := routine_call_stack.count
		end

feature -- Status change

	set_text_color (code: INTEGER)
		require
			valid_code: valid_colors.has (code)
		deferred
		end

	set_text_color_light (code: INTEGER)
		require
			valid_code: valid_colors.has (code)
		deferred
		end

	tab_left
			--
		deferred
		end

	tab_right
			--
		deferred
		end

feature -- Output

	enter (routine_name: STRING )
			-- Enter start of routine
		deferred
		end

	enter_no_header (routine_name: STRING)
			--
		deferred
		end

	enter_with_args (routine_name: STRING; arg_objects: TUPLE)
			--
		deferred
		end

	exit
		deferred
		end

	exit_no_trailer
		deferred
		end

	put_boolean (b: BOOLEAN)
			--
		deferred
		end

	put_character (c: CHARACTER)
			--
		deferred
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		deferred
		end

	put_field_list (max_line_count: INTEGER; list: ARRAY [like NAME_VALUE_PAIR])
		deferred
		end

	put_new_line
			--
		deferred
		end

	put_new_line_x2
		deferred
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
		-- output `a_path' substituting '%S' character for word "file" or "directory"
		deferred
		end

	put_spaces (n: INTEGER)
			--
		deferred
		end

feature -- String output

	put_classname (a_name: READABLE_STRING_8)
		deferred
		end

	put_keyword (keyword: READABLE_STRING_8)
		deferred
		end

	put_labeled_lines (label: READABLE_STRING_GENERAL; lines: ITERABLE [READABLE_STRING_GENERAL])
			--
		deferred
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_labeled_substitution (label, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		deferred
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		deferred
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		deferred
		end

	put_string_field_to_max_length (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		deferred
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
			-- Substitute inserts into template at the '%S' markers
			-- If the tempate has a colon, then apply color highlighting as per `put_labeled_string'
		deferred
		end

feature -- Numeric output

	put_double (d: DOUBLE)
			--
		deferred
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		deferred
		end

	put_integer (i: INTEGER)
			--
		deferred
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		deferred
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		deferred
		end

	put_natural (n: NATURAL)
			--
		deferred
		end

	put_natural_field (label: READABLE_STRING_GENERAL; field_value: NATURAL)
			--
		deferred
		end

	put_real (r: REAL)
			--
		deferred
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		deferred
		end

feature -- Input

	pause_for_enter_key
		deferred
		end

feature {NONE} -- Implementation

	current_routine: EL_LOGGED_ROUTINE
			--
		require
			valid_logged_routine_call_stack: not routine_call_stack.is_empty
		do
			Result := routine_call_stack.item
		end

	routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE]
		-- traced routine call stack

feature {NONE} -- Constants

	Empty_routine_call_stack: ARRAYED_STACK [EL_LOGGED_ROUTINE]
		once
			create Result.make (0)
		end

end