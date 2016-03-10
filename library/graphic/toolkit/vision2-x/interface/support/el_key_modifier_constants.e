note
	description: "Summary description for {EL_KEY_MODIFIER_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_KEY_MODIFIER_CONSTANTS

feature -- Access

	Modifier_none: NATURAL = 0x1

	Modifier_ctrl: NATURAL = 0x2

	Modifier_alt: NATURAL = 0x4

	Modifier_shift: NATURAL = 0x8

end
