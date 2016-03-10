note
	description: "Summary description for {EL_CLASS_FEATURE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 12:15:23 GMT (Friday 4th March 2016)"
	revision: "5"

class
	CLASS_FEATURE

inherit
	COMPARABLE

create
	make, make_with_lines

feature {NONE} -- Initialization

	make (first_line: ZSTRING)
		do
			create lines.make (5)
			lines.extend (first_line)
			update_name
			found_line := Default_line
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

	lines: EIFFEL_SOURCE_LINES

	name: ZSTRING

feature -- Status query

	found: BOOLEAN
		do
			Result := found_line /= Default_line
		end

feature -- Basic operations

	set_lines (a_lines: like lines)
		do
			lines.wipe_out
			a_lines.do_all (agent lines.extend)
			lines.indent (1)
			update_name
			found_line := Default_line
			lines.start
			lines.put_auto_edit_comment_right ("replacement", 3)
		end

	search_substring (substring: ZSTRING)
		do
			lines.find_first (True, agent {ZSTRING}.has_substring (substring))
			if lines.exhausted then
				found_line := Default_line
			else
				found_line := lines.item
			end
		end

feature -- Element change

	expand_shorthand
			-- expand shorthand notation
		local
			line, variable_name: ZSTRING
			pos_marker, i: INTEGER
			variable_name_list: EL_ARRAYED_LIST [ZSTRING]
		do
			line := lines.first
			if line.starts_with (Setter_shorthand) then
				put_attribute_setter_lines (line.substring (7, line.count))

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
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
		do
			Result := name < other.name
		end

feature {NONE} -- Implementation

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
		do
			Atttribute_setter_template.set_variable (once "name", variable_name)
			lines.wipe_out
			across Atttribute_setter_template.substituted.split ('%N') as line loop
				line.item.prepend_character ('%T')
				lines.extend (line.item)
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

feature {NONE} -- Constants

	Argument_template: ZSTRING
		once
			Result := "a_%S: like %S"
		end

	Atttribute_setter_template: EL_SUBSTITUTION_TEMPLATE [ZSTRING]
		once
			create Result.make ("[
				set_$name (a_$name: like $name)
					do
						$name := a_$name
					end

			]")
		end

	Assignment_template: ZSTRING
		once
			Result := "%S := a_%S"
		end

	Boundary_characters: ARRAY [NATURAL]
		once
			Result := << ('(').natural_32_code, (' ').natural_32_code, (';').natural_32_code >>
		end

	Insertion_symbol: ZSTRING
		once
			Result := ":@"
		end

	Keyword_do: ZSTRING
		once
			Result := "do"
		end

	Default_line: ZSTRING
		once
			create Result.make_empty
		end

	Tab_code: NATURAL = 9

	Setter_shorthand: ZSTRING
		once
			Result := "%T@set"
		end

end
