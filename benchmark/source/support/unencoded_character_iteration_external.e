note
	description: "[$source EL_UNENCODED_CHARACTER_ITERATION] that uses inline C for pointer get/set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-25 9:34:22 GMT (Saturday 25th November 2023)"
	revision: "1"

expanded class
	UNENCODED_CHARACTER_ITERATION_EXTERNAL

inherit
	EL_UNENCODED_CHARACTER_ITERATION
		redefine
			put_integer_32, read_integer_32
		end

feature {NONE} -- Implementation

	put_integer_32 (value: INTEGER; integer_ptr: POINTER)
		external
			"C inline"
		alias
			"*(int*)$integer_ptr = (int)$value"
		end

	read_integer_32 (integer_ptr: POINTER): INTEGER
		external
			"C inline"
		alias
			"return (EIF_INTEGER)(*(int*)$integer_ptr)"
		end

end