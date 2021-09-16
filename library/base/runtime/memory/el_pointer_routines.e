note
	description: "Memory pointer routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-15 20:55:51 GMT (Wednesday 15th September 2021)"
	revision: "6"

expanded class
	EL_POINTER_ROUTINES

inherit
	PLATFORM
		export
			{NONE} all
		end

feature -- Status query

	is_attached (a_pointer: POINTER): BOOLEAN
		do
			Result := not a_pointer.is_default_pointer
		end

feature -- Basic operations

	put_integer (value: INTEGER; integer_ptr: POINTER)
		do
			integer_ptr.memory_copy ($value, Integer_32_bytes)
		end

	put_real_32 (value: REAL; real_ptr: POINTER)
		do
			real_ptr.memory_copy ($value, Real_32_bytes)
		end

feature -- Conversion

	read_integer (integer_ptr: POINTER): INTEGER
		do
			($Result).memory_copy (integer_ptr, Integer_32_bytes)
		end

	read_real_32 (real_32_ptr: POINTER): INTEGER
		do
			($Result).memory_copy (real_32_ptr, Real_32_bytes)
		end
end