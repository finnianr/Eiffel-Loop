note
	description: "[
		Latin-1 code string that fits into 8 bytes or less and is initializeable from any of the
		`NATURAL_<X>' numeric data types.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-19 8:27:23 GMT (Sunday 19th June 2022)"
	revision: "3"

class
	EL_CODE_STRING

inherit
	STRING

	EL_SHARED_CODE_REPRESENTATIONS

create
	make_2_max, make_4_max, make_8_max

convert
	make_2_max ({NATURAL_16}), make_4_max ({NATURAL_32}), make_8_max ({NATURAL_64})

feature {NONE} -- Initialization

	make_2_max (n: NATURAL_16)
		-- make code with maximum length of 2 characters
		do
			share (Code_16_representation.to_string (n))
		end

	make_4_max (n: NATURAL_32)
		-- make code with maximum length of 4 characters
		do
			share (Code_32_representation.to_string (n))
		end

	make_8_max (n: NATURAL_64)
		-- make code with maximum length of 8 characters
		do
			share (Code_64_representation.to_string (n))
		end
end