note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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