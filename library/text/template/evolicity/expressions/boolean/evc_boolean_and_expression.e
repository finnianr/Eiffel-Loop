note
	description: "Evolicity boolean and expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:02:02 GMT (Tuesday 18th March 2025)"
	revision: "6"

class
	EVC_BOOLEAN_AND_EXPRESSION

inherit
	EVC_BOOLEAN_CONJUNCTION_EXPRESSION

create
	make

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
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