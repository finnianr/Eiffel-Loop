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
				
		If the type of any argument is known, the explicit type name is used instead of the anchored name.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 9:35:59 GMT (Wednesday 29th May 2024)"
	revision: "7"

class
	MAKE_ROUTINE_FEATURE

inherit
	ROUTINE_FEATURE
		rename
			make as make_feature
		redefine
			expand_shorthand
		end

create
	make

feature {NONE} -- Initialization

	make (line: ZSTRING; a_get_attribute_type: like get_attribute_type)
		do
			make_feature (line)
			get_attribute_type := a_get_attribute_type
		end

feature -- Element change

	expand_shorthand
		local
			variable_name_list: EL_ARRAYED_LIST [ZSTRING]; line, attribute_name, type_name: ZSTRING
			i, pos_marker: INTEGER
		do
			line := lines.first
			create variable_name_list.make (3)
			from pos_marker := 1 until pos_marker = 0 loop
				pos_marker := line.substring_index (Insertion_symbol, pos_marker)
				if pos_marker > 0 then
					from i := pos_marker - 1 until Boundary_characters.has (line.item_8 (i)) or i = 1 loop
						i := i - 1
					end
					attribute_name := line.substring (i + 1, pos_marker - 1)
					type_name := get_attribute_type (attribute_name)
					if type_name.is_empty then
						type_name.share (Like_prefix + attribute_name )
					end
					line.replace_substring (Argument_template #$ [attribute_name, type_name], i + 1, pos_marker + 1)
					variable_name_list.extend (attribute_name)
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
			l_found: BOOLEAN; assignment_code: ZSTRING
		do
			-- Find 'do' keyword
			from lines.start until lines.after or l_found loop
				if lines.item.ends_with (Keyword.do_)
					and then lines.item.z_code (lines.item.count - 2) = Tab_code
				then
					l_found := True
				end
				lines.forth
			end
			if l_found then
				create assignment_code.make_filled ('%T', 3)
				across variable_names as variable loop
					if assignment_code.count > 3 then
						assignment_code.append (Assignment_separator)
					end
					assignment_code.append (Assignment_template #$ [variable.item, variable.item])
				end
				lines.back
				lines.put_right (assignment_code)
			end
		end

feature {NONE} -- Internal attributes

	get_attribute_type: FUNCTION [ZSTRING, ZSTRING]

feature {NONE} -- Constants

	Argument_template: ZSTRING
		once
			Result := "a_%S: %S"
		end

	Assignment_separator: ZSTRING
		once
			Result := "; "
		end

	Assignment_template: ZSTRING
		once
			Result := "%S := a_%S"
		end

	Boundary_characters: STRING = "( ;"

	Insertion_symbol: ZSTRING
		once
			Result := ":@"
		end

end