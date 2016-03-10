note
	description: "Summary description for {EL_ROUTINE_LOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-22 9:59:51 GMT (Tuesday 22nd December 2015)"
	revision: "5"

deferred class
	EL_ROUTINE_LOG

inherit
	EL_LOG
		export
			{NONE} all
		redefine
			-- Basic operations
			put_string, put_labeled_string, put_line, put_string_field, put_string_field_to_max_length,
			put_new_line,

			put_integer, put_character, put_real, put_boolean, put_double,
			put_integer_field, put_integer_interval_field, put_real_field, put_double_field,
			put_elapsed_time,
			restore,
			set_timer,

			-- Status
			current_routine_is_active
		end

feature -- Status

	current_routine_is_active: BOOLEAN
			--
		do
			Result := true
		end

feature -- Element change

	restore (previous_stack_count: INTEGER)
			-- Return tab count to original level before an exception
		local
			l_out: like output
		do
			l_out := output

			l_out.restore (previous_stack_count + 1)
		end

	set_timer
			-- Set routine timer to now
		local
			l_out: like output
		do
			l_out := output
			l_out.put_string (once "TIME: 00:00:00")
			l_out.put_new_line
			l_out.flush
			create timer.make
		end

feature -- Basic operations

	put_boolean (b: BOOLEAN)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_boolean (b)
			l_out.flush
		end

	put_character (c: CHARACTER)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_character (c)
			l_out.flush
		end

	put_double (d: DOUBLE)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_double (d)
			l_out.flush
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_label (label)
			l_out.put_double (field_value)

			l_out.flush
		end

	put_elapsed_time
			-- Log time elapsed since set_timer called
		local
			l_out: like output
		do
			l_out := output

			timer.stop
			l_out.put_label (once "TIME")
			l_out.put_string (timer.out)
			l_out.put_new_line
			l_out.flush
		end

	put_integer (an_integer: INTEGER)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_integer (an_integer)
			l_out.flush
		end

	put_integer_field (label: READABLE_STRING_GENERAL; field_value: INTEGER)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_label (label)
			l_out.put_integer (field_value)

			l_out.flush
		end

	put_integer_interval_field (label: READABLE_STRING_GENERAL; field_value: INTEGER_INTERVAL)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_label (label)
			l_out.put_string (once "[")
			l_out.put_integer (field_value.lower)
			l_out.put_string (once ", ")
			l_out.put_integer (field_value.upper)
			l_out.put_string (once "]")

			l_out.flush
		end

	put_labeled_string (label, str: READABLE_STRING_GENERAL)
			--
		local
			l_out: like output
		do
			l_out := output
			l_out.put_label (label)
			l_out.set_text_brown
			l_out.put_string_general (str)
			l_out.set_text_default
			l_out.flush
		end

	put_line (l: READABLE_STRING_GENERAL)
			-- Put string with new line
		local
			l_out: like output
		do
			l_out := output

			l_out.put_string_general (l)
			l_out.put_new_line
			l_out.flush
		end

	put_new_line
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_new_line
			l_out.flush

		end

	put_real (r: REAL)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_real (r)
			l_out.flush
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.put_label (label)
			l_out.put_real (field_value)

			l_out.flush
		end

	put_string (s: READABLE_STRING_GENERAL)
			--
		local
			l_out: like output
		do
			l_out := output
			l_out.put_string_general (s)
			l_out.flush
		end

	put_string_field (label, field_value: READABLE_STRING_GENERAL)
			--
		local
			l_out: like output
		do
			l_out := output
			l_out.put_label (label)
			l_out.put_quoted_string (field_value)
			l_out.flush
		end

	put_string_field_to_max_length (
		label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER
	)
			-- Put string to log file buffer edited to fit into max_length
		local
			l_out: like output; count_trailing_characters: INTEGER
			l_field_value: ZSTRING; l_lines: EL_ZSTRING_LIST; l_lines_2: LIST [ZSTRING]
		do
			l_out := output
			create l_field_value.make_from_unicode (field_value)
			create l_lines.make (l_field_value.occurrences ('%N') + 2)

			count_trailing_characters := 30
			count_trailing_characters := count_trailing_characters.min (max_length // 3)

			l_out.put_label (label)

			l_out.set_text_brown
			l_out.put_string (once "%"[")
			l_out.set_text_default

			l_out.tab_right
			l_out.put_new_line

			if l_field_value.count > max_length then
				l_lines.append (l_field_value.substring (1, max_length - count_trailing_characters).split ('%N'))
				l_lines.last.append_string (Ellipsis_dots)

				l_lines_2 := l_field_value.substring (
					l_field_value.count - count_trailing_characters + 1, l_field_value.count
				).lines

				l_lines_2.first.prepend_string (Ellipsis_dots)
				l_lines.append (l_lines_2)

			else
				l_lines.append (l_field_value.lines)
			end
			l_out.put_lines (l_lines)
			l_out.tab_left
			l_out.put_new_line

			l_out.set_text_brown
			l_out.put_string (once "]%"")
			l_out.set_text_default

			l_out.flush
		end

feature {NONE} -- Implementation

	output: EL_CONSOLE_LOG_OUTPUT
		deferred
		end

	tab (offset: INTEGER)
			--
		local
			l_out: like output
		do
			l_out := output

			l_out.tab (offset)
		end

	timer: EL_EXECUTION_TIMER

feature {NONE} -- Constants

	Ellipsis_dots: ZSTRING
		once
			Result := ".."
		end
end
