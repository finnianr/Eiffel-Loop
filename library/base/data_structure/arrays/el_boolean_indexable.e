note
	description: "Array that is indexable by a [$source BOOLEAN] value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-19 8:33:48 GMT (Monday 19th April 2021)"
	revision: "3"

class
	EL_BOOLEAN_INDEXABLE [G]

create
	make

feature {NONE} -- Initialization

	make (false_item, true_item: G)
		do
			create area.make_empty (2)
			area.extend (false_item)
			area.extend (true_item)
		end

feature -- Access

	item alias "[]" (boolean: BOOLEAN): G
		do
			Result := area [boolean.to_integer]
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]
end