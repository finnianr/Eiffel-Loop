note
	description: "Pointer routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-15 12:30:40 GMT (Wednesday 15th September 2021)"
	revision: "5"

expanded class
	EL_POINTER_ROUTINES

feature -- Status query

	is_attached (a_pointer: POINTER): BOOLEAN
		do
			Result := not a_pointer.is_default_pointer
		end

feature -- Basic operations

	write_integer (value: INTEGER; integer_ptr: POINTER)
		do
			integer_ptr.memory_copy ($value, {PLATFORM}.Integer_32_bytes)
		end

feature -- Conversion

	integer_value (integer_ptr: POINTER): INTEGER
		do
			($Result).memory_copy (integer_ptr, {PLATFORM}.Integer_32_bytes)
		end
end