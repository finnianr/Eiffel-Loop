note
	description: "Summary description for {EL_LOWERCASE_ALPHA_Z_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-04 14:41:40 GMT (Wednesday 4th April 2018)"
	revision: "3"

class
	EL_LOWERCASE_ALPHA_Z_CHAR_TP

inherit
	EL_LOWERCASE_ALPHA_CHAR_TP
		redefine
			code_matches
		end

	EL_SHARED_ZCODEC

	EL_ZCODE_CONVERSION

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		do
			if z_code <= 0xFF then
				Result := codec.is_lower (z_code)
			else
				Result := z_code_to_unicode (z_code).to_character_32.is_lower
			end
		end

end
