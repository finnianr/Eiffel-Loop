note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
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
