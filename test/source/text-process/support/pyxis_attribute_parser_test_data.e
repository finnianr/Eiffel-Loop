note
	description: "Pyxis attribute parser test data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-10 12:00:34 GMT (Sunday 10th January 2021)"
	revision: "8"

class
	PYXIS_ATTRIBUTE_PARSER_TEST_DATA

feature {NONE} -- Implementation

	attribute_value (object: ANY): STRING
		local
			quote_mark: CHARACTER; i: INTEGER
		do
			if attached {DOUBLE} object as l_double then
				Result := number_to_string (l_double)

			elseif attached {STRING} object as string then
				Result := string.twin
				i := Result.index_of ('%N', 1)
				if i > 0 then
					Result.replace_substring ("\n", i, i)
				end
				if Result.has ('"') then
					quote_mark := '%''
				else
					quote_mark := '"'
				end
				Result.prepend_character (quote_mark)
				Result.append_character (quote_mark)
			else
				Result := object.out
			end
		end

	number_to_string (n: DOUBLE): STRING
		do
			Result := n.out
			if Result.ends_with ("001") then
				 Result.remove_tail (1)
				 Result.prune_all_trailing ('0')
			end
		end

feature -- Constants

	Attribute_table: HASH_TABLE [ANY, STRING]
		once
			create Result.make_equal (10)
			Result ["double"] := 1.5
			Result ["integer"] := 1
			Result ["boolean"] := True
			Result ["string_1"] := "one%Ntwo"
			Result ["string_2"] := "one%"two"
		end

	Attributes_source_line: STRING
		once
			create Result.make (50)
			across Attribute_table as table loop
				if not Result.is_empty then
					Result.append_string_general ("; ")
				end
				Result.append (table.key)
				Result.append_string_general (" = ")
				Result.append (attribute_value (table.item))
			end
		end

	Attributes_comma_separated_values: STRING
		once
			create Result.make (50)
			across Attribute_table as table loop
				if not Result.is_empty then
					Result.append_character (',')
				end
				Result.append_string (attribute_value (table.item))
			end
		end
end