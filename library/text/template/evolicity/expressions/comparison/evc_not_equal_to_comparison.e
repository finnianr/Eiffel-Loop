note
	description: "Evolicity not equal to comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 8:54:12 GMT (Friday 28th March 2025)"
	revision: "3"

class
	EVC_NOT_EQUAL_TO_COMPARISON

inherit
	EVC_EQUAL_TO_COMPARISON
		undefine
			compare, compare_real_64, compare_integer_64
		redefine
			compare_string_8, compare_string_32
		end

create
	make

feature {NONE} -- Implementation

	compare (left, right: COMPARABLE)
			--
		do
			is_true := left /~ right
		end

	compare_real_64 (left, right: REAL_64)
		do
			is_true := left /= right
		end

	compare_integer_64 (left, right: INTEGER_64)
		do
			is_true := left /= right
		end

	compare_string_8 (left: READABLE_STRING_8; right: COMPARABLE; right_type_id: INTEGER)
		do
			Precursor (left, right, right_type_id)
			is_true := not is_true
		end

	compare_string_32 (left: READABLE_STRING_32; right: COMPARABLE; right_type_id: INTEGER)
		do
			Precursor (left, right, right_type_id)
			is_true := not is_true
		end

end