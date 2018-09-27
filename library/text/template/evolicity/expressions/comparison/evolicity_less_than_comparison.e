note
	description: "Evolicity less than comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

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