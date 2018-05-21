note
	description: "Numeric z char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

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