note
	description: "Latin-1 code string that fits into 8 bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-18 17:04:05 GMT (Saturday 18th June 2022)"
	revision: "2"

class
	EL_CODE_STRING

inherit
	STRING

	EL_SHARED_CODE_REPRESENTATIONS

create
	make_2_letters, make_4_letters, make_8_letters

convert
	make_2_letters ({NATURAL_16}), make_4_letters ({NATURAL_32}), make_8_letters ({NATURAL_64})

feature {NONE} -- Initialization

	make_2_letters (n: NATURAL_16)
		do
			share (Code_16_representation.to_string (n))
		end

	make_4_letters (n: NATURAL_32)
		do
			share (Code_32_representation.to_string (n))
		end

	make_8_letters (n: NATURAL_64)
		do
			share (Code_64_representation.to_string (n))
		end
end