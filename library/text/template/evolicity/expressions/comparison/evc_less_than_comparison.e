note
	description: "Evolicity less than comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-20 10:01:28 GMT (Thursday 20th March 2025)"
	revision: "9"

class
	EVC_LESS_THAN_COMPARISON

inherit
	EVC_COMPARISON
		rename
			compare_like_string_8 as compare_string_8,
			compare_like_string_32 as compare_string_32
		end

create
	default_create

feature {NONE} -- Implementation

	compare (left, right: COMPARABLE)
			--
		do
			is_true := left < right
		end

	compare_real_64 (left, right: REAL_64)
		do
			is_true := left < right
		end

	compare_integer_64 (left, right: INTEGER_64)
		do
			is_true := left < right
		end

end