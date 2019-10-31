note
	description: "Libid3 cpp api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 12:30:26 GMT (Thursday   31st   October   2019)"
	revision: "2"

class
	LIBID3_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Externals

	c_is_single_byte_encoding (enc: INTEGER): BOOLEAN
			--
		external
			"C++ [macro %"id3/tag.h%"] (EIF_INTEGER): EIF_BOOLEAN"
		alias
			"ID3TE_IS_SINGLE_BYTE_ENC"
		end
end
