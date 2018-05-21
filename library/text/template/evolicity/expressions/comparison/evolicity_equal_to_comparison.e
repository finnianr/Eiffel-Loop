note
	description: "Evolicity equal to comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EVOLICITY_EQUAL_TO_COMPARISON

inherit
	EVOLICITY_COMPARISON

feature {NONE} -- Implementation

	compare
			--
		do
			is_true := left_comparable.is_equal (right_comparable)
		end

end