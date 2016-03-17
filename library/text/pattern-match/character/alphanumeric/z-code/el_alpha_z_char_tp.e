note
	description: "Summary description for {EL_ALPHABETICAL_ZCHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 14:22:31 GMT (Saturday 26th December 2015)"
	revision: "5"

class
	EL_ALPHA_Z_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			code_matches
		end

	EL_SHARED_ZCODEC

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		do
			if z_code <= 0xFF then
				Result := codec.is_alpha (z_code)
			else
				Result := Precursor (z_code_to_unicode (z_code))
			end
		end

end
