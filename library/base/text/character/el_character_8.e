note
	description: "[$source CHARACTER_8_REF] with conversion to [$source STRING_8] by `*' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-11 15:47:08 GMT (Friday 11th August 2023)"
	revision: "3"

class
	EL_CHARACTER_8

inherit
	CHARACTER_8_REF

create
	make

convert
	make ({CHARACTER_8}), item: {CHARACTER_8}

feature {NONE} -- Initialization

	make (c: CHARACTER_8)
		do
			set_item (c)
		end

feature -- Access

	multiplied alias "*" (n: INTEGER): STRING_8
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.n_character_string (item, n)
		end

	as_zstring alias "#*" (n: INTEGER): ZSTRING
		-- multiplied as shared `ZSTRING'
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.n_character_string (item, n)
		end

	as_string_32 (n: INTEGER): STRING_32
		-- multiplied as shared `STRING_32'
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.n_character_string (item, n)
		end
end