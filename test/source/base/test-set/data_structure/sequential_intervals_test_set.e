note
	description: "Sequential intervals test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:29:39 GMT (Friday 10th March 2023)"
	revision: "13"

class
	SEQUENTIAL_INTERVALS_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["item_count", agent test_item_count]
			>>)
		end

feature -- Tests

	test_item_count
		local
			str: ZSTRING; has_item_count_zero: BOOLEAN
			list: EL_SEQUENTIAL_INTERVALS; s: EL_ZSTRING_ROUTINES
		do
			str := "A B C "
			list := str.split_intervals (s.character_string (' '))
			assert ("count is 4", list.count = 4)
			list.finish
			assert ("last item is empty", str.substring (list.item_lower, list.item_upper).is_empty)
			from list.start until has_item_count_zero or list.after loop
				if list.item_count = 0 then
					has_item_count_zero := True
				end
				list.forth
			end
			assert ("has_item_count_zero", has_item_count_zero)
		end
end