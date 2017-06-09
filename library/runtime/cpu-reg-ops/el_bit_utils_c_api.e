note
	description: "Summary description for {BIT_UTILS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-03 6:47:18 GMT (Saturday 3rd June 2017)"
	revision: "1"

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
