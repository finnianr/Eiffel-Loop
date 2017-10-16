note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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