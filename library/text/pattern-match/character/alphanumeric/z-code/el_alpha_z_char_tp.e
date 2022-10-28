note
	description: "Match alphabetical character if source string is [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-26 21:16:51 GMT (Wednesday 26th October 2022)"
	revision: "8"

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