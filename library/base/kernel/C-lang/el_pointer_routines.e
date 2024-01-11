note
	description: "Memory pointer routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:13:30 GMT (Thursday 11th January 2024)"
	revision: "15"

expanded class
	EL_POINTER_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	PLATFORM
		export
			{NONE} all
		end

feature -- Write to memory

	i_th_lower_upper (area: SPECIAL [INTEGER]; i: INTEGER; upper_ptr: TYPED_POINTER [INTEGER]): INTEGER
		-- i'th lower index setting integer at `upper_ptr' memory location as a side-effect
		-- (Keeping for benchmark code `P_I_TH_LOWER_UPPER_VS_INLINE_CODE')
		obsolete
			"Too slow: inline code is faster x 100"
		require
			attached_upper: upper_ptr /= default_pointer
		local
			j, k: INTEGER
		do
			j := (i - 1) * 2; k := j + 1
			if k < area.count then
				Result := area [j]
				put_integer_32 (area [k], upper_ptr)
			else
				Result := 1
			end
		end

	put_integer_32 (value: INTEGER; integer_ptr: TYPED_POINTER [INTEGER])
		do
			integer_ptr.memory_copy ($value, Integer_32_bytes)
		end

	put_real_32 (value: REAL; real_ptr: TYPED_POINTER [REAL])
		do
			real_ptr.memory_copy ($value, Real_32_bytes)
		end

feature -- Read from memory

	read_integer_32 (integer_ptr: TYPED_POINTER [INTEGER]): INTEGER
		do
			($Result).memory_copy (integer_ptr, Integer_32_bytes)
		end

	read_real_32 (real_32_ptr: TYPED_POINTER [REAL]): INTEGER
		do
			($Result).memory_copy (real_32_ptr, Real_32_bytes)
		end
end