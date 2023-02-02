note
	description: "[
		[$source EL_NATURAL_32_BIT_ROUTINES] that **shift_count** using gcc built-in function
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-02 16:00:32 GMT (Thursday 2nd February 2023)"
	revision: "3"

expanded class
	NATURAL_32_BIT_ROUTINES_V4

inherit
	EL_NATURAL_32_BIT_ROUTINES
		redefine
			shift_count
		end

feature -- Measurement

	shift_count (mask: NATURAL_32): INTEGER
		do
			Result := count_trailing_zeros (mask)
		ensure then
			same_result: Result = shift_count_precursor (mask)
  		end

feature -- Contract Support

	shift_count_precursor (mask: NATURAL_32): INTEGER
		local
			n32: EL_NATURAL_32_BIT_ROUTINES
		do
			Result := n32.shift_count (mask)
		end

feature {NONE} -- Externals

	frozen count_trailing_zeros (x: NATURAL_32): INTEGER
			-- gcc Built-in Function: int __builtin_ctz (unsigned int x)
		external
			"C (unsigned int): EIF_INTEGER | <eif_config.h>"
		alias
			"__builtin_ctz"
		end
end