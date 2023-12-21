note
	description: "Silent 'do nothing' log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-21 9:30:41 GMT (Thursday 21st December 2023)"
	revision: "21"

class
	EL_SILENT_LOG

inherit
	EL_LOGGABLE
		rename
			make_default as make
		end

create
	make

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
		end

feature {EL_CONSOLE_ONLY_LOG} -- Basic operations

	clear
		-- clear screen		
		do
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		do
		end

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

	set_text_color (code: INTEGER)
		do
		end

	set_text_color_light (code: INTEGER)
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

	enter_with_args (routine_name: STRING; arg_objects: TUPLE)
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

	put_field_list (max_line_length: INTEGER; list: ARRAY [like name_value_pair])
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

	put_spaces (n: INTEGER)
			--
		do
		end

feature -- String output

	put_classname (a_name: READABLE_STRING_8)
		do
		end

	put_index_labeled_string (indexable: ANY; label_or_format: detachable READABLE_STRING_GENERAL; str: READABLE_STRING_GENERAL)
		do
		end

	put_keyword (keyword: READABLE_STRING_8)
		do
		end

	put_labeled_lines (label: READABLE_STRING_GENERAL; lines: ITERABLE [READABLE_STRING_GENERAL])
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

	put_string (s: READABLE_STRING_GENERAL)
			--
		do
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		do
		end

	put_curtailed_string_field (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		do
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
		end

feature -- Numeric output

	put_double (d: DOUBLE; a_format: detachable STRING)
			--
		do
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE; a_format: detachable STRING)
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

	put_natural (n: NATURAL)
			--
		do
		end

	put_natural_field (label: READABLE_STRING_GENERAL; field_value: NATURAL)
		do
		end

	put_real (r: REAL; a_format: detachable STRING)
			--
		do
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL; a_format: detachable STRING)
			--
		do
		end

end