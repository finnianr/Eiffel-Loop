note
	description: "Summary description for {EL_NUMERIC_Z_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_NUMERIC_Z_CHAR_TP

inherit
	EL_NUMERIC_CHAR_TP
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
				Result := codec.is_numeric (z_code)
			end
		end
end