note
	description: "Summary description for {BIT_UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_BIT_UTILS_C_API

feature {NONE} -- C externals

	natural_32_bit_count (n: NATURAL): INTEGER
		external
			"C (EIF_NATURAL): EIF_INTEGER | <bit-utils.h>"
		alias
			"builtin_bit_count"
		end

end
