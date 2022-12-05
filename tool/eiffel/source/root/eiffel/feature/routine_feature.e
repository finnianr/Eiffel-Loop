note
	description: "Routine feature"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:17:41 GMT (Monday 5th December 2022)"
	revision: "5"

class
	ROUTINE_FEATURE

inherit
	CLASS_FEATURE

create
	make, make_with_lines

feature -- Element change

	expand_shorthand
			-- expand shorthand notation
		local
			pos_at_from, tab_count: INTEGER; from_shorthand_found: BOOLEAN
			line: ZSTRING
		do
			line := lines.first
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
				from lines.forth until lines.after or else lines.item.starts_with_zstring (Body_end_line) loop
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
			if until_expression.ends_with_zstring (Dot_after)
				or else until_expression.ends_with_zstring (Dot_before)
			then
				pos_dot := until_expression.index_of ('.', 1)
				if pos_dot > 0 then
					l_name := until_expression.substring (1, pos_dot - 1)
					if until_expression.ends_with_zstring (Dot_after) then
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
				pos_do := line.substring_index (Keyword.do_, 1)
				if pos_do > 0 and then line.leading_occurrences ('%T') = pos_do - 1
					and then (pos_do + 1 = line.count or else line.is_space_item (pos_do + 1))
				then
					found_do := True
				else
					lines.forth
				end
			end
		end

feature {NONE} -- String Constants

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

	Loop_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				from $initial until $expression loop
					$increment
				end
			]")
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

end