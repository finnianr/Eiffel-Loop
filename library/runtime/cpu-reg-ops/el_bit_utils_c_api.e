note
	description: "Bit utils c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

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