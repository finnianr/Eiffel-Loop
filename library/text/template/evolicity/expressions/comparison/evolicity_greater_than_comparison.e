note
	description: "Evolicity greater than comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EVOLICITY_GREATER_THAN_COMPARISON

inherit
	EVOLICITY_COMPARISON

feature {NONE} -- Implementation

	compare (left, right: COMPARABLE)
			--
		do
			is_true := left > right
		end

	compare_double (left, right: DOUBLE)
		do
			is_true := left > right
		end

	compare_integer_64 (left, right: INTEGER_64)
		do
			is_true := left > right
		end

	compare_string (left, right: READABLE_STRING_GENERAL)
		do
			is_true := left > right
		end

end