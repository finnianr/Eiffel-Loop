note
	description: "Summary description for {LIBID3_CPP_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_CPP_API

feature {NONE} -- Externals

	c_is_single_byte_encoding (enc: INTEGER): BOOLEAN
			--
		external
			"C++ [macro %"id3/tag.h%"] (EIF_INTEGER): EIF_BOOLEAN"
		alias
			"ID3TE_IS_SINGLE_BYTE_ENC"
		end
end
