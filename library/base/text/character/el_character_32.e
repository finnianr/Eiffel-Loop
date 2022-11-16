note
	description: "[$source CHARACTER_32_REF] with conversion to [$source ZSTRING] by `*' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_CHARACTER_32

inherit
	CHARACTER_32_REF

create
	make

convert
	make ({CHARACTER})

feature {NONE} -- Initialization

	make (uc: CHARACTER)
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