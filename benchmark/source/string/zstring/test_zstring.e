note
	description: "Test zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 12:18:22 GMT (Saturday 5th April 2025)"
	revision: "8"

class
	TEST_ZSTRING

inherit
	TEST_STRINGS [ZSTRING, ZSTRING_ROUTINES]

create
	make

feature -- Measurement

	storage_bytes (s: ZSTRING): INTEGER
		do
			Result := property (s).physical_size + property (s.area).physical_size
			if s.has_mixed_encoding then
				Result := Result + property (s.unencoded_area).physical_size
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