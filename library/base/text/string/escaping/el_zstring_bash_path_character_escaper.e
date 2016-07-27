note
	description: "Summary description for {EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-22 19:19:19 GMT (Tuesday 22nd December 2015)"
	revision: "5"

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