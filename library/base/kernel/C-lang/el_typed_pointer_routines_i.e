note
	description: "Extra routines for class ${TYPED_POINTER}"
	notes: "[
		RESULTS: perform benchmark
		Passes over 500 millisecs (in descending order)

			external inline C:  1078.0 times (100%)
			memory_copy:        813.0 times (-24.6%)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-08-17 12:00:00 GMT (Monday 17th August 2026)"
	revision: "3"

deferred class
	EL_TYPED_POINTER_ROUTINES_I

inherit
	EL_ROUTINES

feature {NONE} -- Write to memory

	put_natural_64 (value: NATURAL_64; natural_64_ptr: TYPED_POINTER [NATURAL_64])
		external
			"C inline use <eif_eiffel.h>"
		alias
			"*$natural_64_ptr = $value;"
		end

	put_integer_32 (value: INTEGER; integer_ptr: TYPED_POINTER [INTEGER])
		external
			"C inline use <eif_eiffel.h>"
		alias
			"*$integer_ptr = $value;"
		end

	put_real_32 (value: REAL; real_ptr: TYPED_POINTER [REAL])
		external
			"C inline use <eif_eiffel.h>"
		alias
			"*$real_ptr = $value;"
		end

	put_boolean (value: BOOLEAN; boolean_ptr: TYPED_POINTER [BOOLEAN])
		external
			"C inline use <eif_eiffel.h>"
		alias
			"*$boolean_ptr = $value;"
		end

feature {NONE} -- Read from memory

	read_integer_32 (integer_ptr: TYPED_POINTER [INTEGER]): INTEGER
		external
			"C inline use <eif_eiffel.h>"
		alias
			"return *$integer_ptr;"
		end

	read_natural_64 (natural_64_ptr: TYPED_POINTER [NATURAL_64]): NATURAL_64
		external
			"C inline use <eif_eiffel.h>"
		alias
			"return *$natural_64_ptr;"
		end

	read_real_32 (real_32_ptr: TYPED_POINTER [REAL]): INTEGER
		external
			"C inline use <eif_eiffel.h>"
		alias
			"return *$real_32_ptr;"
		end

end
