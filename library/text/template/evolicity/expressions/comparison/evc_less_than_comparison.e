note
	description: "Evolicity less than comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 22:07:07 GMT (Tuesday 18th March 2025)"
	revision: "8"

class
	EVC_LESS_THAN_COMPARISON

inherit
	EVC_COMPARISON

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

	compare_string (left, right: ZSTRING)
		do
			is_true := left < right
		end

end