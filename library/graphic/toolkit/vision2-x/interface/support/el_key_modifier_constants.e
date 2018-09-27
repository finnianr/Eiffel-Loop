note
	description: "Key modifier constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_KEY_MODIFIER_CONSTANTS

feature -- Access

	Modifier_none: NATURAL = 0x1

	Modifier_ctrl: NATURAL = 0x2

	Modifier_alt: NATURAL = 0x4

	Modifier_shift: NATURAL = 0x8

end