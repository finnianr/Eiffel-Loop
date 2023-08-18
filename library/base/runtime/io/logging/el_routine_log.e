note
	description: "Routine log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 5:49:22 GMT (Thursday 17th August 2023)"
	revision: "32"

deferred class
	EL_ROUTINE_LOG

inherit
	EL_LOGGABLE

	EL_MODULE_TUPLE

	EL_MODULE_REUSEABLE

	EL_CHARACTER_8_CONSTANTS

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

	put_index_labeled_string (indexable: ANY; label: detachable READABLE_STRING_GENERAL; str: READABLE_STRING_GENERAL)
		-- output integer index value associated with `indexable' object that may conform to one of:
		--		`LINEAR', `INDEXABLE_ITERATION_CURSOR', `INTEGER_32_REF', `NATURAL_32_REF'

		-- An optional formatting `label' that may contain an index substitution character '%S' (Eg. "item [%S]")
		-- otherwise `label' is used to prefix index value
		do
			if attached output as op then
				op.put_index_label (indexable, label)
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
				op.put_quoted_string (field_value, Double_quote)
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

				if field_value.count > max_length then
					leading_count := (max_length * 0.8).rounded; trailing_count := (max_length * 0.2).rounded

					across Reuseable.string as reuse loop
						if attached reuse.substring_item (field_value, 1, leading_count) as str then
							str.right_adjust
							str.append_string (Ellipisis_break)
							str.append_from_right_general (field_value, trailing_count)
							create line_list.make_with_lines (str)
						end
					end
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

	Double_quote: STRING = "%""

	Ellipisis_break: ZSTRING
		once
			Result := "..%N%N.."
		end

	Single_quote: STRING = "'"

	Timer: EL_EXECUTION_TIMER
		once ("OBJECT")
			create Result.make
		end
end