note
	description: "Extra routines for class ${TYPED_POINTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 7:22:55 GMT (Saturday 19th April 2025)"
	revision: "2"

deferred class
	EL_TYPED_POINTER_ROUTINES_I

inherit
	EL_ROUTINES

feature {NONE} -- Write to memory

	put_integer_32 (value: INTEGER; integer_ptr: TYPED_POINTER [INTEGER])
		do
			integer_ptr.memory_copy ($value, {PLATFORM}.Integer_32_bytes)
		end

	put_real_32 (value: REAL; real_ptr: TYPED_POINTER [REAL])
		do
			real_ptr.memory_copy ($value, {PLATFORM}.Real_32_bytes)
		end

feature {NONE} -- Read from memory

	read_integer_32 (integer_ptr: TYPED_POINTER [INTEGER]): INTEGER
		do
			($Result).memory_copy (integer_ptr, {PLATFORM}.Integer_32_bytes)
		end

	read_real_32 (real_32_ptr: TYPED_POINTER [REAL]): INTEGER
		do
			($Result).memory_copy (real_32_ptr, {PLATFORM}.Real_32_bytes)
		end
end