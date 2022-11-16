note
	description: "Key modifier constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_KEY_MODIFIER_CONSTANTS

feature -- Access

	Modifier_none: NATURAL = 0x1

	Modifier_ctrl: NATURAL = 0x2

	Modifier_alt: NATURAL = 0x4

	Modifier_shift: NATURAL = 0x8

end