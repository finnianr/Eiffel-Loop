note
	description: "Latin 1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:27:47 GMT (Tuesday 20th August 2024)"
	revision: "7"

class
	EL_LATIN_1

feature -- Ascii

	Ucase_A: NATURAL = 65

	Ucase_Z: NATURAL = 90

	Lcase_a: NATURAL = 97

	Lcase_z: NATURAL = 122

feature -- Latin 1 upper boundaries

	Ucase_A_GRAVE: NATURAL = 192
		-- � Capital A, grave accent

	Ucase_THORN: NATURAL = 222
		-- � Capital THORN, Icelandic

feature -- Latin 1 lower boundaries

	Lcase_a_grave: NATURAL = 224
		-- � Small a, grave accent

	Lcase_thorn: NATURAL = 254
		-- � Small thorn, Icelandic

feature -- Latin 1 upper/lower exceptions

	Multiply_sign: NATURAL = 215 -- In lower

	Division_sign: NATURAL = 247 -- In upper

feature -- Latin 1 undefined case

	Sharp_s: NATURAL = 223
		-- � Small sharp s

	Y_dieresis: NATURAL = 255
		-- � Small y, dieresis

end