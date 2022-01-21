note
	description: "[$source CHARACTER_32_REF] with conversion to [$source ZSTRING] by `*' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-20 18:48:20 GMT (Thursday 20th January 2022)"
	revision: "1"

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