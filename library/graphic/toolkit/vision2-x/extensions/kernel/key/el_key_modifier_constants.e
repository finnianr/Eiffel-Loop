note
	description: "Key modifier constants that can be combined with ${NATURAL_32}.bit_xor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 7:08:38 GMT (Thursday 18th July 2024)"
	revision: "8"

class
	EL_KEY_MODIFIER_CONSTANTS

feature {NONE} -- Constants

	Alt: NATURAL = 0x1

	Ctrl: NATURAL = 0x2

	Shift: NATURAL = 0x4

	Valid_modifiers: ARRAY [NATURAL]
		once
			Result := << Alt, Ctrl, Shift >>
		end

end