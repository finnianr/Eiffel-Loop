note
	description: "Evolicity boolean reference expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EVOLICITY_BOOLEAN_REFERENCE_EXPRESSION

inherit
	EVOLICITY_BOOLEAN_EXPRESSION

	EVOLICITY_REFERENCE_EXPRESSION

create
	make

feature -- Basic operation

	evaluate (context: EVOLICITY_CONTEXT)
			--
		do
			if attached {BOOLEAN_REF} context.referenced_item (variable_ref) as boolean_ref then
				is_true := boolean_ref.item
			end
		end

end