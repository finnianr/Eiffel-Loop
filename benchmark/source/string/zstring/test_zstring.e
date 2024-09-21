note
	description: "Test zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 7:48:54 GMT (Friday 20th September 2024)"
	revision: "7"

class
	TEST_ZSTRING

inherit
	TEST_STRINGS [ZSTRING, ZSTRING_ROUTINES]

create
	make

feature -- Measurement

	storage_bytes (s: ZSTRING): INTEGER
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
			if s.has_mixed_encoding then
				Result := Result + Eiffel.physical_size (s.unencoded_area)
			end
		end

feature {NONE} -- Factory

	new_character_set (str: ZSTRING): EL_HASH_SET [CHARACTER_32]
		do
			create Result.make (str.count // 2)
			across str as uc loop
				Result.put (uc.item)
			end
		end

feature {NONE} -- Constants

	Unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (C_escape_table)
		end

end