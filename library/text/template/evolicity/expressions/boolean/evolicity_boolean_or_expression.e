note
	description: "Summary description for {EVOLICITY_BOOLEAN_OR_EXPRESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EVOLICITY_BOOLEAN_OR_EXPRESSION

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
				is_true := true
			else
				right.evaluate (context)
				if right.is_true then
					is_true := true
				end
			end
		end

end