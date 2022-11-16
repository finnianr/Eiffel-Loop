note
	description: "White space z char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_WHITE_SPACE_Z_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		redefine
			code_matches
		end

	EL_SHARED_ZSTRING_CODEC

	EL_ZCODE_CONVERSION

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			if z_code <= 0xFF then
				Result := z_code.to_character_8.is_space
			else
				-- Work around for finalization bug
				Result := c.is_space (z_code_to_unicode (z_code).to_character_32)
			end
		end
end