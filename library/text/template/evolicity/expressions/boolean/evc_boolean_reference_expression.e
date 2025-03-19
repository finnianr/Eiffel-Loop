note
	description: "Evolicity boolean reference expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:05 GMT (Tuesday 18th March 2025)"
	revision: "6"

class
	EVC_BOOLEAN_REFERENCE_EXPRESSION

inherit
	EVC_BOOLEAN_EXPRESSION

	EVC_REFERENCE_EXPRESSION

create
	make

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
			--
		do
			if attached {BOOLEAN_REF} context.referenced_item (variable_ref) as boolean_ref then
				is_true := boolean_ref.item
			end
		end

end