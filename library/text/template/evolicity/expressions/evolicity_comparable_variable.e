note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-24 16:02:17 GMT (Sunday 24th November 2013)"
	revision: "2"

class
	EVOLICITY_COMPARABLE_VARIABLE

inherit
	EVOLICITY_REFERENCE_EXPRESSION

	EVOLICITY_COMPARABLE
		redefine
			evaluate
		end

create
	make

feature -- Basic operation

	evaluate (context: EVOLICITY_CONTEXT)
			--
		do
			if attached {COMPARABLE} context.referenced_item (variable_ref) as comparable then
				item := comparable
			end
		ensure then
			item_set: item /= Void
		end

end
