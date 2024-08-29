note
	description: "Array that is indexable by a ${BOOLEAN} value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-29 14:42:17 GMT (Thursday 29th August 2024)"
	revision: "8"

class
	EL_BOOLEAN_INDEXABLE [G]

create
	make, make_with_function, make_with_tuple

convert
	make_with_tuple ({TUPLE [G, G]}), make_with_function ({FUNCTION [BOOLEAN, G]})

feature {NONE} -- Initialization

	make_with_tuple (t: TUPLE [false_item, true_item: G])
		do
			make (t.false_item, t.true_item)
		end

	make (false_item, true_item: G)
		do
			create area.make_filled (false_item, 2)
			area [1] := true_item
		end

	make_with_function (true_item: FUNCTION [BOOLEAN, G])
		require
			open_argument: true_item.open_count = 1
		do
			make (true_item (False), true_item (True))
		end

feature -- Access

	first, item_false: G
		-- `item (False)'
		do
			Result := area [0]
		end

	item alias "[]", item_1 alias "#?" (boolean: BOOLEAN): G
		do
			Result := area [boolean.to_integer]
		end

	last, item_true: G
		-- `item (True)'
		do
			Result := area [1]
		end

feature -- Status query

	for_all (test: PREDICATE [G]): BOOLEAN
		do
			Result := area.for_all_in_bounds (test, 0, 1)
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]
end