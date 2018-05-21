note
	description: "Evolicity less than comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EVOLICITY_LESS_THAN_COMPARISON

inherit
	EVOLICITY_COMPARISON

create
	default_create

feature {NONE} -- Implementation

	compare
			--
		do
			is_true := left_comparable < right_comparable
		end

end