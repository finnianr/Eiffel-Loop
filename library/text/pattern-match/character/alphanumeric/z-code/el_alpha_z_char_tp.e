note
	description: "Alpha z char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 13:37:44 GMT (Thursday 14th May 2020)"
	revision: "7"

class
	EL_ALPHA_Z_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			code_matches
		end

	EL_SHARED_ZSTRING_CODEC

	EL_ZCODE_CONVERSION

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		do
			if z_code <= 0xFF then
				Result := codec.is_alpha (z_code)
			else
				Result := z_code_to_unicode (z_code).to_character_32.is_alpha
			end
		end

end
