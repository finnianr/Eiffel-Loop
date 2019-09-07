note
	description: "Basic string template to substitute variables names starting with $"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]

create
	make

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
		local
			list: EL_SPLIT_STRING_LIST [S]
			i, length: INTEGER
		do
			create list.make (new_string (a_template), Dollor_sign)
			create variable_values.make (list.count)
			create part_list.make (list.count * 2)
			from list.start until list.after loop
				if list.index = 1 then
					if not list.item.is_empty then
						part_list.extend (list.item.twin)
					end
				else
					length := 0
					from i := 1 until i > list.item.count loop
						inspect list.item [i]
							when 'a'.. 'z', 'A'.. 'Z', '0' .. '9', '_' then
								length := length + 1
								i := i + 1
						else
							i := list.item.count + 1
						end
					end
					variable_values.put (create {S}.make_empty, list.item.substring (1, length).to_string_8)
					part_list.extend (variable_values.found_item)
					if length < list.item.count then
						part_list.extend (list.item.substring (length + 1, list.item.count))
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

	put (name: STRING; value: S)
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

feature -- Status query

	has (name: STRING): BOOLEAN
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

	variable_values: HASH_TABLE [S, STRING]
		-- variable name list

feature {NONE} -- Constants

	Dollor_sign: STRING = "$"

end
