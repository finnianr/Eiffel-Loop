note
	description: "Bit utils c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "2"

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
