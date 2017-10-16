note
	description: "Summary description for {EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER

inherit
	EL_BASH_PATH_CHARACTER_ESCAPER [ZSTRING]
		redefine
			append_escape_sequence
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: ZSTRING; code: NATURAL)
		do
			str.append_z_code  (('\').natural_32_code)
			str.append_unicode (code)
		end
end