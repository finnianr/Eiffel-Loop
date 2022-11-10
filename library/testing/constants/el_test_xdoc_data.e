note
	description: "XML or Pyxis related document data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-09 8:18:43 GMT (Wednesday 9th November 2022)"
	revision: "11"

class
	EL_TEST_XDOC_DATA

inherit
	ANY

	EL_SHARED_TEST_NUMBERS

feature -- Access

	pyxis_attribute_value (object: ANY): STRING
		local
			quote_mark: CHARACTER; i: INTEGER
		do
			if attached {DOUBLE} object as l_double then
				Result := Number.double_to_string (l_double)

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

	pyxis_attributes_line (a_table: like Attribute_table): STRING
		do
			create Result.make (50)
			across a_table as table loop
				if not Result.is_empty then
					Result.append_string_general ("; ")
				end
				Result.append (table.key)
				Result.append_string_general (" = ")
				Result.append (pyxis_attribute_value (table.item))
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

	Attributes_comma_separated_values: STRING
		once
			create Result.make (50)
			across Attribute_table as table loop
				if not Result.is_empty then
					Result.append_character (',')
				end
				Result.append_string (pyxis_attribute_value (table.item))
			end
		end

	Xpaths: STRING = "[
		head/meta[@name='title']/@content
		body/seq
		@id
		audio
	]"
end