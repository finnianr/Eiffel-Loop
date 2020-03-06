note
	description: "Class feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-06 11:49:34 GMT (Friday 6th March 2020)"
	revision: "14"

deferred class
	CLASS_FEATURE

inherit
	ANY

	EL_ZSTRING_CONSTANTS

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
			lines.find_first_true (agent {ZSTRING}.has_substring (substring))
			if lines.exhausted then
				found_line := Empty_string
			else
				found_line := lines.item
			end
		end

	expand_shorthand
			-- expand shorthand notation
		deferred
		end

feature -- Element change

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

	Keyword_do: ZSTRING
		once
			Result := "do"
		end

	Numeric_increment: ZSTRING
		once
			Result := "%S := %S + 1"
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
