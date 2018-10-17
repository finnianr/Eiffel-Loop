note
	description: "Class feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:47:15 GMT (Wednesday 17th October 2018)"
	revision: "9"

class
	CLASS_FEATURE

inherit
	COMPARABLE

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal
		end

create
	make, make_with_lines

feature {NONE} -- Initialization

	make (first_line: ZSTRING)
		do
			create lines.make (5)
			lines.extend (first_line)
			update_name
			found_line := Empty_string
		end

	make_with_lines (a_lines: like lines)
		do
			make (a_lines.first)
			across a_lines as line loop
				if line.cursor_index > 1 then
					lines.extend (line.item)
				end
			end
			lines.start
			lines.put_auto_edit_comment_right ("new insertion", 3)
		end

feature -- Access

	found_line: ZSTRING

	lines: SOURCE_LINES

	name: ZSTRING

feature -- Status query

	found: BOOLEAN
		do
			Result := found_line /= Empty_string
		end

feature -- Basic operations

	search_substring (substring: ZSTRING)
		do
			lines.find_first (True, agent {ZSTRING}.has_substring (substring))
			if lines.exhausted then
				found_line := Empty_string
			else
				found_line := lines.item
			end
		end

feature -- Element change

	expand_shorthand
			-- expand shorthand notation
		local
			line, variable_name: ZSTRING; variable_name_list: EL_ARRAYED_LIST [ZSTRING]
			pos_marker, i, pos_at_from, tab_count: INTEGER; from_shorthand_found: BOOLEAN
		do
			line := lines.first
			if line.starts_with (Setter_shorthand) then
				put_attribute_setter_lines (line.substring_end (Setter_shorthand.count + 2))

			elseif line.has_substring (Insertion_symbol) then
				create variable_name_list.make (3)
				from pos_marker := 1 until pos_marker = 0 loop
					pos_marker := line.substring_index (Insertion_symbol, pos_marker)
					if pos_marker > 0 then
						from i := pos_marker - 1 until Boundary_characters.has (line.z_code (i)) or i = 1 loop
							i := i - 1
						end
						variable_name := line.substring (i + 1, pos_marker - 1)
						line.replace_substring (Argument_template #$ [variable_name, variable_name], i + 1, pos_marker + 1)
						variable_name_list.extend (variable_name)
					end
				end
				if not variable_name_list.is_empty then
					insert_attribute_assignments (variable_name_list)
				end
			end
			across body_interval as n until from_shorthand_found loop
				lines.go_i_th (n.item)
				line := lines.item
				pos_at_from := line.substring_index (From_shorthand, 1)
				if pos_at_from > 0 then
					tab_count := line.leading_occurrences ('%T')
					if tab_count + 1 = pos_at_from then
						from_shorthand_found := True
					end
				end
			end
			if from_shorthand_found then
				replace_line (expanded_from_loop (line.substring_end (pos_at_from + From_shorthand.count + 1)), tab_count)
			end
		end

	set_lines (a_lines: like lines)
		do
			lines.wipe_out
			a_lines.do_all (agent lines.extend)
			lines.indent (1)
			update_name
			found_line := Empty_string
			lines.start
			lines.put_auto_edit_comment_right ("replacement", 3)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
		do
			Result := name < other.name
		end

feature {NONE} -- Implementation

	body_interval: INTEGER_INTERVAL
			-- lines between do and end
		local
			lower, upper: INTEGER
		do
			search_do_keyword
			if lines.after then
				lower := 1
			else
				lower := lines.index + 1
				from lines.forth until lines.after or else lines.item.starts_with (Body_end_line) loop
					lines.forth
				end
				if lines.after then
					upper := lower - 1
				else
					upper := lines.index - 1
				end
			end
			Result := lower |..| upper
		end

	expanded_from_loop (until_expression: ZSTRING): SOURCE_LINES
		local
			pos_space, pos_dot: INTEGER; loop_code, l_name: ZSTRING
		do
			create loop_code.make_empty
			Loop_template.set_variable ("expression", until_expression)
			if until_expression.ends_with (Dot_after) or else until_expression.ends_with (Dot_before) then
				pos_dot := until_expression.index_of ('.', 1)
				if pos_dot > 0 then
					l_name := until_expression.substring (1, pos_dot - 1)
					if until_expression.ends_with (Dot_after) then
						Loop_template.set_variable (Var_initial, l_name + ".start")
						Loop_template.set_variable (Var_increment, l_name + ".forth")
					else
						Loop_template.set_variable (Var_initial, l_name + ".finish")
						Loop_template.set_variable (Var_increment, l_name + ".back")
					end
					loop_code := Loop_template.substituted
				end
			else
				pos_space := until_expression.index_of (' ', 1)
				if pos_space > 0 then
					l_name := until_expression.substring (1, pos_space - 1)
					Loop_template.set_variable (Var_initial, l_name + " := 1")
					Loop_template.set_variable (Var_increment, Numeric_increment #$ [l_name, l_name])
					loop_code := Loop_template.substituted
				end
			end
			create Result.make_with_lines (loop_code)
		end

	insert_attribute_assignments (variable_names: EL_ARRAYED_LIST [ZSTRING])
		local
			l_found: BOOLEAN
			assignment_code: ZSTRING
		do
			-- Find 'do' keyword
			from lines.start until lines.after or l_found loop
				if lines.item.ends_with (Keyword_do) and then lines.item.z_code (lines.item.count - 2) = Tab_code then
					l_found := True
				end
				lines.forth
			end
			if l_found then
				create assignment_code.make_filled ('%T', 3)
				across variable_names as variable loop
					if assignment_code.count > 3 then
						assignment_code.append_string_general (once "; ")
					end
					assignment_code.append (Assignment_template #$ [variable.item, variable.item])
				end
				lines.back
				lines.put_right (assignment_code)
			end
		end

	put_attribute_setter_lines (variable_name: ZSTRING)
		local
			setter_lines: EL_ZSTRING_LIST
		do
			Atttribute_setter_template.set_variable (once "name", variable_name)
			lines.wipe_out
			create setter_lines.make_with_lines (Atttribute_setter_template.substituted)
			setter_lines.indent (1)
			lines.append (setter_lines)

			name.wipe_out
			name.append_string_general ("set_")
			name.append (variable_name)
		end

	replace_line (a_lines: like lines; tab_count: INTEGER)
		do
			if not lines.after then
				a_lines.indent (tab_count)
				lines.remove; lines.back
				lines.merge_right (a_lines)
			end
		end

	search_do_keyword
		local
			pos_do: INTEGER; found_do: BOOLEAN
			line: ZSTRING
		do
			from lines.start until found_do or else lines.after loop
				line := lines.item
				pos_do := line.substring_index (Keyword_do, 1)
				if pos_do > 0 and then line.leading_occurrences ('%T') = pos_do - 1
					and then (pos_do + 1 = line.count or else line.is_space_item (pos_do + 1))
				then
					found_do := True
				else
					lines.forth
				end
			end
		end

	update_name
		do
			name := lines.first.twin
			name.left_adjust; name.right_adjust
			if name.has (' ') then
				name := name.substring (1, name.index_of (' ', 1) - 1)
				name.prune_all_trailing (':')
			end
		end

feature {NONE} -- String Constants

	Argument_template: ZSTRING
		once
			Result := "a_%S: like %S"
		end

	Assignment_template: ZSTRING
		once
			Result := "%S := a_%S"
		end

	Body_end_line: ZSTRING
		once
			Result := "%T%Tend"
		end

	Dot_after: ZSTRING
		once
			Result := ".after"
		end

	Dot_before: ZSTRING
		once
			Result := ".before"
		end

	From_shorthand: ZSTRING
		once
			Result := "@from"
		end

	Insertion_symbol: ZSTRING
		once
			Result := ":@"
		end

	Keyword_do: ZSTRING
		once
			Result := "do"
		end

	Numeric_increment: ZSTRING
		once
			Result := "%S := %S + 1"
		end

	Setter_shorthand: ZSTRING
		once
			Result := "%T@set"
		end

	Var_increment: ZSTRING
		once
			Result := "increment"
		end

	Var_initial: ZSTRING
		once
			Result := "initial"
		end

feature {NONE} -- Constants

	Boundary_characters: ARRAY [NATURAL]
		once
			Result := << ('(').natural_32_code, (' ').natural_32_code, (';').natural_32_code >>
		end

	Atttribute_setter_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				set_$name (a_$name: like $name)
					do
						$name := a_$name
					end

			]")
		end

	Loop_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				from $initial until $expression loop
					$increment
				end
			]")
		end

	Tab_code: NATURAL = 9

end
