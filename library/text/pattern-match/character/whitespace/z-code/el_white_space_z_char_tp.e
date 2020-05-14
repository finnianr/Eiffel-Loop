note
	description: "White space z char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 13:37:46 GMT (Thursday 14th May 2020)"
	revision: "8"

class
	EL_WHITE_SPACE_Z_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		redefine
			code_matches
		end

	EL_SHARED_ZSTRING_CODEC

	EL_ZCODE_CONVERSION

	EL_MODULE_CHAR_32

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		do
			if z_code <= 0xFF then
				Result := z_code.to_character_8.is_space
			else
				-- Work around for finalization bug
				Result := Char_32.is_space (z_code_to_unicode (z_code).to_character_32)
			end
		end
end
