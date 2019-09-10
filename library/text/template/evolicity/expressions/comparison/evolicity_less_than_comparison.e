note
	description: "Evolicity less than comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-09 13:56:45 GMT (Monday 9th September 2019)"
	revision: "5"

class
	EVOLICITY_LESS_THAN_COMPARISON

inherit
	EVOLICITY_COMPARISON

create
	default_create

feature {NONE} -- Implementation

	compare (left, right: COMPARABLE)
			--
		do
			is_true := left < right
		end

	compare_double (left, right: DOUBLE)
		do
			is_true := left < right
		end

	compare_integer_64 (left, right: INTEGER_64)
		do
			is_true := left < right
		end

end
