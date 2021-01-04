note
	description: "Array with binary entries for true and false"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-04 11:54:10 GMT (Monday 4th January 2021)"
	revision: "1"

class
	EL_BOOLEAN_ARRAY [G]

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

	item (boolean: BOOLEAN): G
		do
			Result := area [boolean.to_integer]
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]
end