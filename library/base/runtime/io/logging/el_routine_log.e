note
	description: "Routine log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 12:05:11 GMT (Saturday 3rd December 2022)"
	revision: "23"

deferred class
	EL_ROUTINE_LOG

inherit
	EL_LOGGABLE

feature -- Status

	current_routine_is_active: BOOLEAN
			--
		do
			Result := true
		end

feature {EL_CONSOLE_ONLY_LOG, EL_MODULE_LIO} -- Element change

	set_logged_object (current_logged_object: ANY)
			--
		do
		end

feature -- Element change

	restore (previous_stack_count: INTEGER)
			-- Return tab count to original level before an exception
		do
			if attached output as op then
				op.restore (previous_stack_count + 1)
			end
		end

feature -- Basic operations

	clear
		-- clear screen		
		do
			output.clear
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		do
			output.move_cursor_up (n)
		end

	set_timer
			-- Set routine Timer to now
		do
			put_labeled_string (once "TIME", once "0 secs 0 ms")
			put_new_line
			Timer.start
		end

feature -- Status change

	set_text_color (code: INTEGER)
		do
			output.set_text_color (code)
		end

	set_text_color_light (code: INTEGER)
		do
			output.set_text_color_light (code)
		end

	tab_left
			--
		do
			output.tab_left
		end

	tab_right
			--
		do
			output.tab_right
		end

feature -- Input

	pause_for_enter_key
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
			if attached output as op then
				op.put_boolean (b)
				op.flush
			end
		end

	put_character (c: CHARACTER)
			--
		do
			if attached output as op then
				op.put_character (c)
				op.flush
			end
		end

	put_configuration_info (log_filters: ARRAYED_LIST [EL_LOG_FILTER])
		do
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		do
			Timer.stop
			put_labeled_string (once "TIME", Timer.elapsed_time.out)
			put_new_line
		end

	put_new_line
			--
		do
			if attached output as op then
				op.put_new_line
				op.flush
			end
		end

	put_new_line_x2
		do
			if attached output as op then
				op.put_new_line; op.put_new_line
				op.flush
			end
		end

	put_path_field (label: READABLE_STRING_GENERAL; a_path: EL_PATH)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_path (a_path)
				op.flush
			end
		end

	put_spaces (n: INTEGER)
			--
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached output as op then
				op.put_string (s.n_character_string (' ', n))
				op.flush
			end
		end

feature -- String output

	put_classname (a_name: READABLE_STRING_8)
		do
			if attached output as op then
				op.put_classname (a_name)
				op.flush
			end
		end

	put_keyword (keyword: READABLE_STRING_8)
		do
			if attached output as op then
				op.put_keyword (keyword)
				op.flush
			end
		end

	put_labeled_lines (label: READABLE_STRING_GENERAL; line_list: ITERABLE [READABLE_STRING_GENERAL])
		local
			not_first: BOOLEAN
		do
			if attached output as op then
				op.put_label (label)
				op.tab_right
				op.put_new_line
				op.set_text_color (Color.Yellow)
				across line_list as list loop
					if not_first then
						op.put_new_line
					else
						not_first := True
					end
					op.put_string_general (list.item)
				end
				op.tab_left
				op.put_new_line
				op.set_text_color (Color.Default)
				op.flush
			end
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.set_text_color (Color.Yellow)
				op.put_string_general (str)
				op.set_text_color (Color.Default)
				op.flush
			end
		end

	put_labeled_substitution (label, template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			put_labeled_string (label, substituted (template, inserts))
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- Put string with new line
		do
			if attached output as op then
				op.put_string_general (l)
				op.put_new_line
				op.flush
			end
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		do
			if attached output as op then
				op.put_string_general (s)
				op.flush
			end
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_quoted_string (field_value, Double_quote)
				op.flush
			end
		end

	put_string_field_to_max_length (
		label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER
	)
			-- Put string to log file buffer edited to fit into max_length
		local
			l_field_value: ZSTRING; l_lines: EL_ZSTRING_LIST; l_lines_2: LIST [ZSTRING]
			count_trailing_characters: INTEGER
		do
			if attached output as op then
				create l_field_value.make_from_general (field_value)
				create l_lines.make (l_field_value.occurrences ('%N') + 2)

				count_trailing_characters := 30
				count_trailing_characters := count_trailing_characters.min (max_length // 3)

				op.put_label (label)

				op.set_text_color (Color.Yellow)
				op.put_string (once "%"[")
				op.set_text_color (Color.Default)

				op.tab_right
				op.put_new_line

				if l_field_value.count > max_length then
					l_lines.append (l_field_value.substring (1, max_length - count_trailing_characters).split_list ('%N'))
					l_lines.last.append_string (Ellipsis_dots)

					l_lines_2 := l_field_value.substring_end (l_field_value.count - count_trailing_characters + 1).lines

					l_lines_2.first.prepend_string (Ellipsis_dots)
					l_lines.append (l_lines_2)

				else
					l_lines.append (l_field_value.lines)
				end
				op.put_lines (l_lines)
				op.tab_left
				op.put_new_line

				op.set_text_color (Color.Yellow)
				op.put_string (once "]%"")
				op.set_text_color (Color.Default)

				op.flush
			end
		end

	put_substitution (template: READABLE_STRING_GENERAL; inserts: TUPLE)
		do
			put_string (substituted (template, inserts))
		end

feature -- Numeric output

	put_double (d: DOUBLE)
			--
		do
			if attached output as op then
				op.put_double (d)
				op.flush
			end
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_double (field_value)

				op.flush
			end
		end

	put_integer (an_integer: INTEGER)
			--
		do
			if attached output as op then
				op.put_integer (an_integer)
				op.flush
			end
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_integer (field_value)

				op.flush
			end
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_string (once "[")
				op.put_integer (field_value.lower)
				op.put_string (once ", ")
				op.put_integer (field_value.upper)
				op.put_string (once "]")

				op.flush
			end
		end

	put_natural (n: NATURAL)
			--
		do
			if attached output as op then
				op.put_natural (n)
				op.flush
			end
		end

	put_natural_field (label: READABLE_STRING_GENERAL; field_value: NATURAL)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_natural (field_value)

				op.flush
			end
		end

	put_real (r: REAL)
			--
		do
			if attached output as op then
				op.put_real (r)
				op.flush
			end
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_real (field_value)

				op.flush
			end
		end

feature {NONE} -- Implementation

	output: EL_CONSOLE_LOG_OUTPUT
		deferred
		end

	substituted (template: READABLE_STRING_GENERAL; inserts: TUPLE): ZSTRING
		local
			l_template: ZSTRING
		do
			if attached {ZSTRING} template as zstr then
				l_template := zstr
			else
				create l_template.make_from_general (template)
			end
			Result := l_template #$ inserts
		end

feature {NONE} -- Constants

	Double_quote: STRING = "%""

	Ellipsis_dots: ZSTRING
		once
			Result := ".."
		end

	Single_quote: STRING = "'"

	Timer: EL_EXECUTION_TIMER
		once ("OBJECT")
			create Result.make
		end
end