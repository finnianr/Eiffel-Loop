note
	description: "Evolicity equal to comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-22 19:01:18 GMT (Friday 22nd November 2019)"
	revision: "6"

class
	EVOLICITY_EQUAL_TO_COMPARISON

inherit
	EVOLICITY_COMPARISON

feature {NONE} -- Implementation

	compare (left, right: COMPARABLE)
			--
		do
			is_true := left.is_equal (right)
		end

	compare_double (left, right: DOUBLE)
		do
			is_true := left = right
		end

	compare_integer_64 (left, right: INTEGER_64)
		do
			is_true := left = right
		end

	compare_string (left, right: READABLE_STRING_GENERAL)
		do
			is_true := left.same_string (right)
		end

end
