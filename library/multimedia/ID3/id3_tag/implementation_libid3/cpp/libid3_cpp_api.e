note
	description: "Libid3 cpp api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

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