note
	description: "Routine log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 9:47:23 GMT (Wednesday 19th February 2025)"
	revision: "40"

deferred class
	EL_ROUTINE_LOG

inherit
	EL_LOGGABLE

	EL_MODULE_TUPLE

	EL_CHARACTER_8_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_POOL

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

	put_field_list (max_line_count: INTEGER; list: ARRAY [like name_value_pair])
		local
			field: like name_value_pair; line_count, field_count, value_count: INTEGER
			real_string: detachable STRING; quoted_string: detachable READABLE_STRING_GENERAL
		do
			across list as list_tuple loop
				field := list_tuple.item; quoted_string := Void; real_string := Void

				if attached new_real_string (field) as str then
					value_count := str.count
					real_string := str
				elseif field.item_code (2) = {TUPLE}.Reference_code
					and then attached {READABLE_STRING_GENERAL} field.reference_item (2) as str
					and then str.has (' ')
				then
					quoted_string := str
					value_count := str.count + 2
				else
					value_count := Tuple.i_th_string_width (field, 2)
				end
				field_count := field.name.count + value_count + 2 -- (": ").count
				if line_count > 0 then
					field_count := field_count + 1 -- + space
				end
				if line_count + field_count > max_line_count then
					line_count := 0; field_count := field_count - 1 -- remove space
					put_new_line
				end
				if line_count.to_boolean then
					put_character (' ')
				end
				put_field (field, quoted_string, real_string)
				line_count := line_count + field_count
			end
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
		do
			if attached output as op then
				op.put_string (space * n)
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

	put_columns (lines: ITERABLE [READABLE_STRING_GENERAL]; column_count, maximum_width: INTEGER)
		-- display lines across `column_count' columns with `maximum_width' characters
		-- if `maximum_width' is 0 then calculate maximum width of 'lines'
		local
			line_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
			row, column, row_count, index, padding_width, max_column_width, line_count: INTEGER
			use_substring: BOOLEAN
		do
			create line_list.make_from_list (lines)

			row_count := line_list.count // column_count
			if line_list.count \\ column_count > 0 then
				row_count := row_count + 1
			end
			if maximum_width = 0 then
				max_column_width := line_list.max_integer (agent {READABLE_STRING_GENERAL}.count)
			else
				use_substring := True
				max_column_width := maximum_width
			end

			if attached output as op then
				from row := 0 until row = row_count loop
					from column := 1 until column > column_count loop
						index := (column - 1) * row_count + row + 1
						if line_list.valid_index (index) then
							line_count := line_list [index].count
							if use_substring and then line_count > max_column_width then
								op.put_string (line_list [index].substring (1, max_column_width))
							else
								op.put_string (line_list [index])
							end
							if column < column_count then
								if use_substring then
									padding_width := max_column_width - line_count.min (max_column_width) + 1
								else
									padding_width := max_column_width - line_count + 1
								end
								op.put_string (Space * padding_width)
							end
						end
						column := column + 1
					end
					op.put_new_line
					row := row + 1
				end
				op.flush
			end
		end

	put_index_labeled_string (indexable: ANY; label_or_format: detachable READABLE_STRING_GENERAL; str: READABLE_STRING_GENERAL)
		-- output integer index value associated with `indexable' object that may conform to one of:
		--		`LINEAR', `INDEXABLE_ITERATION_CURSOR', `INTEGER_32_REF', `NATURAL_32_REF'

		-- An optional formatting `label_or_format' that may be interpreted in the following ways:

		--		1. A template if it contains a substitution placeholder '%S' for the `indexable' value (Eg. "i_th [%S]")
		--		2. A padding format for the `indexable' value if all the characters are equal to '9'
		--		3. Or else a prefix before the `indexable' value
		do
			if attached output as op then
				op.put_index_label (indexable, label_or_format)
				op.set_text_color (Color.Yellow)
				op.put_string_general (str)
				op.set_text_color (Color.Default)
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
				op.put_quoted_string (field_value)
				op.flush
			end
		end

	put_curtailed_string_field (label, field_value: READABLE_STRING_GENERAL; max_length: INTEGER)
		-- Put string to log file buffer edited to fit into max_length
		local
			line_list: EL_ZSTRING_LIST; leading_count, trailing_count: INTEGER
		do
			if not field_value.has ('%N') and field_value.count <= max_length then
				put_string_field (label, field_value)

			elseif attached output as op then
				op.put_label (label)

				op.set_text_color (Color.Yellow)
				op.put_string (once "%"[")
				op.set_text_color (Color.Default)

				op.tab_right
				op.put_new_line

				if field_value.count > max_length and then attached String_pool.borrowed_item as borrowed then
					leading_count := (max_length * 0.8).rounded; trailing_count := (max_length * 0.2).rounded

					if attached borrowed.copied_substring_general (field_value, 1, leading_count) as str then
						str.right_adjust
						str.append_string (Ellipisis_break)
						str.append_from_right_general (field_value, trailing_count)
						create line_list.make_with_lines (str)
					end
					borrowed.return
				else
					create line_list.make_with_lines (field_value)
				end

				line_list.expand_tabs (op.Tab_string.count)
				op.put_lines (line_list)
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

	put_double (d: DOUBLE; a_format: detachable STRING)
			--
		do
			if attached output as op then
				op.put_double (d, a_format)
				op.flush
			end
		end

	put_double_field (label: READABLE_STRING_GENERAL; field_value: DOUBLE; a_format: detachable STRING)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_double (field_value, a_format)

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
				op.put_string (char ('['))
				op.put_integer (field_value.lower)
				op.put_string (once ", ")
				op.put_integer (field_value.upper)
				op.put_string (char (']'))

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

	put_real (r: REAL; a_format: detachable STRING)
			--
		do
			if attached output as op then
				op.put_real (r, a_format)
				op.flush
			end
		end

	put_real_field (label: READABLE_STRING_GENERAL; field_value: REAL; a_format: detachable STRING)
			--
		do
			if attached output as op then
				op.put_label (label)
				op.put_real (field_value, a_format)

				op.flush
			end
		end

feature {NONE} -- Implementation

	new_real_string (field: like name_value_pair): detachable STRING
		do
			inspect field.item_code (2)
				when {TUPLE}.Real_32_code then
					Result := field.real_32_item (2).out
				when {TUPLE}.Real_64_code then
					Result := field.real_64_item (2).out
			else
			end
		end

	output: EL_CONSOLE_LOG_OUTPUT
		deferred
		end

	put_field (
		field: like name_value_pair; quoted_string: detachable READABLE_STRING_GENERAL; real_string: detachable STRING
	)
		local
			string_value: detachable READABLE_STRING_GENERAL
		do
			if attached quoted_string as str then
				put_string_field (field.name, str)

			elseif attached real_string as str then
				put_labeled_string (field.name, str)
			else
				inspect field.item_code (2)
					when {TUPLE}.Integer_32_code then
						put_integer_field (field.name, field.integer_32_item (2))
					when {TUPLE}.Natural_32_code then
						put_natural_field (field.name, field.natural_32_item (2))
					when {TUPLE}.Reference_code then
						if attached field.reference_item (2) as ref_item then
							if attached {READABLE_STRING_GENERAL} ref_item as str then
								string_value := str
							elseif attached {EL_PATH} ref_item as path then
								put_path_field (field.name, path)
							elseif attached {PATH} ref_item as path then
								string_value := path.name
							else
								string_value := field.item (2).out
							end
						end
				else
					string_value := field.item (2).out
				end
				if attached string_value as value then
					put_labeled_string (field.name, value)
				end
			end
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

	Ellipisis_break: ZSTRING
		once
			Result := "..%N%N.."
		end

	Timer: EL_EXECUTION_TIMER
		once ("OBJECT")
			create Result.make
		end
end