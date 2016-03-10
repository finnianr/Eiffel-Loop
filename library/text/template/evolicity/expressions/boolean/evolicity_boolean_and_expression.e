note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

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
