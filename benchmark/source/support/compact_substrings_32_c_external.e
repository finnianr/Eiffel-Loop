note
	description: "${EL_COMPACT_SUBSTRINGS_32_ITERATION} that uses inline C for pointer get/set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "5"

expanded class
	COMPACT_SUBSTRINGS_32_C_EXTERNAL

inherit
	EL_COMPACT_SUBSTRINGS_32_ITERATION
		redefine
			put_integer_32, read_integer_32
		end

feature {NONE} -- Implementation

	put_integer_32 (value: INTEGER; integer_ptr: TYPED_POINTER [INTEGER])
		external
			"C inline"
		alias
			"*(int*)$integer_ptr = (int)$value"
		end

	read_integer_32 (integer_ptr: TYPED_POINTER [INTEGER]): INTEGER
		external
			"C inline"
		alias
			"return (EIF_INTEGER)(*(int*)$integer_ptr)"
		end

end