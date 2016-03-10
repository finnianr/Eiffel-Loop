note
	description: "Summary description for {EL_LATIN_1}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LATIN_1

feature -- Ascii

	Ucase_A: NATURAL = 65

	Ucase_Z: NATURAL = 90

	Lcase_a: NATURAL = 97

	Lcase_z: NATURAL = 122

feature -- Latin 1 upper boundaries

	Ucase_A_GRAVE: NATURAL = 192
		-- À: Capital A, grave accent

	Ucase_THORN: NATURAL = 222
		-- Þ: Capital THORN, Icelandic

feature -- Latin 1 lower boundaries

	Lcase_a_grave: NATURAL = 224
		-- à: Small a, grave accent

	Lcase_thorn: NATURAL = 254
		-- þ: Small thorn, Icelandic

feature -- Latin 1 upper/lower exceptions

	Multiply_sign: NATURAL = 215 -- In lower

	Division_sign: NATURAL = 247 -- In upper

feature -- Latin 1 undefined case

	Sharp_s: NATURAL = 223
		-- ß: Small sharp s

	Y_dieresis: NATURAL = 255
		-- ÿ: Small y, dieresis

end
