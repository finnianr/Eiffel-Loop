note
	description: "Basic string template to substitute variables names starting with $"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-29 10:09:52 GMT (Sunday 29th August 2021)"
	revision: "5"

class
	EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

create
	make

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
		local
			list: EL_SPLIT_STRING_LIST [S]; item: S
			i, length, start_index, end_index: INTEGER; has_braces: BOOLEAN
		do
			create list.make (new_string (a_template), Dollor_sign)
			create variable_values.make_size (list.count)
			create part_list.make (list.count * 2)
			from list.start until list.after loop
				item := list.item (False)
				if list.index = 1 then
					if not item.is_empty then
						part_list.extend (item.twin)
					end
				else
					length := 0; has_braces := False
					from i := 1 until i > item.count loop
						inspect item [i]
							when 'a'.. 'z', 'A'.. 'Z', '0' .. '9', '_', '{' then
								length := length + 1
								i := i + 1
							when '}' then
								length := length + 1
								i := item.count + 1
								has_braces := True
						else
							i := item.count + 1
						end
					end
					if has_braces then
						start_index := 2; end_index := length - 1
					else
						start_index := 1; end_index := length
					end
					variable_values.put (create {S}.make_empty, item.substring (start_index, end_index).to_string_8)
					part_list.extend (variable_values.found_item)
					if length < item.count then
						part_list.extend (item.substring (length + 1, item.count))
					end
				end
				list.forth
			end
		end

feature -- Access

	substituted: S
			--
		do
			Result := part_list.joined_strings
		end

feature -- Element change

	put (name: READABLE_STRING_8; value: S)
		require
			has_name: has (name)
		do
			if variable_values.has_key (name) then
				if attached {BAG [ANY]} variable_values.found_item as bag then
					bag.wipe_out
				end
				variable_values.found_item.append (value)
			end
		end

	put_general (name: READABLE_STRING_8; value: READABLE_STRING_GENERAL)
		do
			if attached {S} value as str then
				put (name, str)
			else
				put (name, new_string (value))
			end
		end

feature -- Status query

	has (name: READABLE_STRING_8): BOOLEAN
		do
			Result := variable_values.has (name)
		end

feature {NONE} -- Implementation

	new_string (str: READABLE_STRING_GENERAL): S
		do
			create Result.make (str.count)
			Result.append (str)
		end

feature {NONE} -- Internal attributes

	part_list: EL_STRING_LIST [S]

	variable_values: EL_STRING_8_TABLE [S]
		-- variable name list

feature {NONE} -- Constants

	Dollor_sign: STRING = "$"

end