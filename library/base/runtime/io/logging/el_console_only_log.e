note
	description: "[
		Minimal console only log accessed by the `lio' object in class ${EL_MODULE_LIO}
		It is effectively just an extension of the standard `io' object. It can be optionally integrated with
		the Eiffel-Loop logging system.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:48 GMT (Sunday 30th March 2025)"
	revision: "34"

class
	EL_CONSOLE_ONLY_LOG

inherit
	EL_LOGGABLE
		rename
			make_default as make
		redefine
			make
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_CONSOLE

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create {EL_CONSOLE_ROUTINE_LOG} log_sink.make (new_output)
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			-- For use in routines that did not call enter to
			-- push routine on to call stack
		do
		end

feature -- Input

	pause_for_enter_key
		do
		end

feature -- Basic operations

	clear
		-- clear screen		
		do
			log_sink.clear
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		do
			log_sink.move_cursor_up (n)
		end

feature -- Status change

	set_text_color (code: INTEGER)
		do
			log_sink.set_text_color (code)
		end

	set_text_color_light (code: INTEGER)
		do
			log_sink.set_text_color_light (code)
		end

	tab_left
			--
		do
			log_sink.tab_left
		end

	tab_right
			--
		do
			log_sink.tab_right
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
			log_sink.put_boolean (b)
		end

	put_character (c: CHARACTER)
			--
		do
			log_sink.put_character (c)
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		do
			log_sink.put_elapsed_time
		end

	put_field_list (max_line_length: INTEGER; list: ARRAY [like name_value_pair])
		do
			log_sink.put_field_list (max_line_length, list)
		end

	put_new_line
			--
		do
			log_sink.put_new_line
		end

	put_new_line_x2
			--
		do
			log_sink.put_new_line
			log_sink.put_new_line
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
		--
		local
			l_label: ZSTRING; index: INTEGER
		do
			if label.has ('%S') then
				l_label := as_zstring (label) #$ [a_path.type_alias]
				if not attached {EL_URI_PATH} a_path then
					index := l_label.substring_index (a_path.type_alias, 1)
					-- Lower-case it if not not at start
					if index > 1 then
						l_label.put (l_label [index].as_lower, index)
					end
				end
				log_sink.put_string_field (l_label, a_path)
			else
				log_sink.put_string_field (label, a_path)
			end
		end

	put_spaces (n: INTEGER)
			--
		do
			log_sink.put_spaces (n)
		end

feature -- String output

	put_classname (a_name: READABLE_STRING_8)
		do
			log_sink.put_classname (a_name)
		end

	put_columns (lines: ITERABLE [READABLE_STRING_GENERAL]; column_count, maximum_width: INTEGER)
		-- display lines across `column_count' columns with `maximum_width' characters
		-- if `maximum_width' is 0 then calculate maximum width of 'lines'
		do
			log_sink.put_columns (lines, column_count, maximum_width)
		end

	put_index_labeled_string (indexable: ANY; label_or_format: detachable READABLE_STRING_GENERAL; str: READABLE_STRING_GENERAL)
		-- output integer index value associated with `indexable' object that may conform to one of:
		--		`LINEAR', `INDEXABLE_ITERATION_CURSOR', `INTEGER_32_REF', `NATURAL_32_REF'

		-- An optional formatting `label_or_format' that may be interpreted in the following ways:

		--		1. A template if it contains a substitution placeholder '%S' for the `indexable' value (Eg. "i_th [%S]")
		--		2. A padding format for the `indexable' value if all the characters are equal to '9'
		--		3. Or else a prefix before the `indexable' value
		do
			log_sink.put_index_labeled_string (indexable, label_or_format, str)
		end

	put_keyword (keyword: READABLE_STRING_8)
		do
			log_sink.put_keyword (keyword)
		end

	put_labeled_lines (label: READABLE_STRING_GENERAL; lines: ITERABLE [READABLE_STRING_GENERAL])
		do
			log_sink.put_labeled_lines (label, lines)
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_labeled_string (label, str)
		end

	put_labeled_substitution (label, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			log_sink.put_labeled_substitution (label, template, inserts)
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- put string with new line
		do
			log_sink.put_line (l)
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_string (s)
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		do
			log_sink.put_string_field (label, field_value)
		end

	put_curtailed_string_field (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
			-- Put string to log file edited to fit into max_length
		do
			log_sink.put_curtailed_string_field (label, field_value, max_length)
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			log_sink.put_substitution (template, inserts)
		end

feature -- Numeric output

	put_double (d: DOUBLE; a_format: detachable STRING)
			--
		do
			log_sink.put_double (d, a_format)
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE; a_format: detachable STRING)
			--
		do
			log_sink.put_double_field (label, field_value, a_format)
		end

	put_integer (i: INTEGER)
			--
		do
			log_sink.put_integer (i)
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		do
			log_sink.put_integer_field (label, field_value)
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		do
			log_sink.put_integer_interval_field (label, field_value)
		end

	put_natural (n: NATURAL)
			--
		do
			log_sink.put_natural (n)
		end

	put_natural_field (label: READABLE_STRING_GENERAL; field_value: NATURAL)
			--
		do
			log_sink.put_natural_field (label, field_value)
		end

	put_real (r: REAL; a_format: detachable STRING)
			--
		do
			log_sink.put_real (r, a_format)
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL; a_format: detachable STRING)
			--
		do
			log_sink.put_real_field (label, field_value, a_format)
		end

feature {EL_LOG_HANDLER} -- Element change

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
			log_sink.set_timer
		end

	set_log_sink (a_log_sink: like log_sink)
		do
			log_sink := a_log_sink
		end

feature {NONE} -- Implementation

	new_output: EL_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create Result.make
			end
		end

feature {EL_LOG_HANDLER} -- Internal attributes

	log_sink: EL_LOGGABLE

end