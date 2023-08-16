note
	description: "[$source CHARACTER_32_REF] with conversion to [$source ZSTRING] by `*' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-10 8:01:57 GMT (Thursday 10th August 2023)"
	revision: "3"

class
	EL_CHARACTER_32

inherit
	CHARACTER_32_REF

create
	make_8, make_32

convert
	make_8 ({CHARACTER_8}), make_32 ({CHARACTER_32}), item: {CHARACTER_32}

feature {NONE} -- Initialization

	make_8 (c: CHARACTER_8)
		do
			make_32 (c)
		end

	make_32 (uc: CHARACTER_32)
		do
			set_item (uc)
		end

feature -- Access

	multiplied alias "*" (n: INTEGER): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.n_character_string (item, n)
		end
end