note
	description: "Evolicity comparable variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-20 8:32:50 GMT (Thursday 20th March 2025)"
	revision: "7"

class
	EVC_COMPARABLE_VARIABLE

inherit
	EVC_REFERENCE_EXPRESSION
		redefine
			make
		end

	EVC_COMPARABLE
		rename
			make as make_comparable
		redefine
			evaluate
		end

create
	make

feature {NONE} -- Initialization

	make (a_variable_ref: like variable_ref)
		do
			make_comparable (Default_item)
			Precursor (a_variable_ref)
		end

feature -- Basic operation

	evaluate (context: EVC_CONTEXT)
			--
		do
			if attached {COMPARABLE} context.referenced_item (variable_ref) as comparable then
				item := comparable
			end
		ensure then
			item_set: item /= Default_item
		end

feature {NONE} -- Constants

	Default_item: INTEGER_REF
		once
			create Result
		end

end