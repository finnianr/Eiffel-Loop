note
	description: "[
		Expands make routine containing expandable signature types with names identical to class attributes
		
		**UNEXPANDED**

			make (arg_1:@; arg_2:@; ..)
				do
					..
				end
				
		**EXPANDED**

			make (a_arg_1: like arg_1; a_arg_2: like arg_2; ..)
				do
					arg_1 := a_arg_1; arg_2 := a_arg_2
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 9:45:10 GMT (Saturday 5th February 2022)"
	revision: "3"

class
	MAKE_ROUTINE_FEATURE

inherit
	ROUTINE_FEATURE
		redefine
			expand_shorthand
		end

create
	make

feature -- Element change

	expand_shorthand
		local
			variable_name_list: EL_ARRAYED_LIST [ZSTRING]; line, variable_name: ZSTRING
			i, pos_marker: INTEGER
		do
			line := lines.first
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
			Precursor
		end

feature {NONE} -- Implementation

	insert_attribute_assignments (variable_names: EL_ARRAYED_LIST [ZSTRING])
		local
			l_found: BOOLEAN
			assignment_code: ZSTRING
		do
			-- Find 'do' keyword
			from lines.start until lines.after or l_found loop
				if lines.item.ends_with (Keyword.do_) and then lines.item.z_code (lines.item.count - 2) = Tab_code then
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

feature {NONE} -- Constants

	Argument_template: ZSTRING
		once
			Result := "a_%S: like %S"
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

end