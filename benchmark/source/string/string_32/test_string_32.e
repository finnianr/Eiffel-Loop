note
	description: "Test string 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 7:48:42 GMT (Friday 20th September 2024)"
	revision: "6"

class
	TEST_STRING_32

inherit
	TEST_STRINGS [STRING_32, STRING_32_ROUTINES]

create
	make

feature -- Measurement

	storage_bytes (s: STRING_32): INTEGER
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
		end

feature {NONE} -- Factory

	new_character_set (str: STRING_32): EL_HASH_SET [CHARACTER_32]
		do
			create Result.make (str.count // 2)
			across str as uc loop
				Result.put (uc.item)
			end
		end

feature {NONE} -- Constants

	Unescaper: EL_STRING_32_UNESCAPER
		once
			create Result.make (C_escape_table)
		end

end