note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EVOLICITY_BOOLEAN_AND_EXPRESSION

inherit
	EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION

create
	make

feature -- Basic operation

	evaluate (context: EVOLICITY_CONTEXT)
			--
		do
			is_true := false
			left.evaluate (context)
			if left.is_true then
				right.evaluate (context)
				if right.is_true then
					is_true := true
				end
			end
		end

end
