note
	description: "Summary description for {EL_SEQUENTIAL_INTERVALS_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 14:28:08 GMT (Monday 9th April 2018)"
	revision: "2"

class
	SEQUENTIAL_INTERVALS_TEST_SET

inherit
	EQA_TEST_SET

	EL_STRING_CONSTANTS
		undefine
			default_create
		end

feature -- Tests

	test_item_count
		local
			str: ZSTRING; has_item_count_zero: BOOLEAN
			list: EL_SEQUENTIAL_INTERVALS
		do
			str := "A B C "
			list := str.split_intervals (Space_string)
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
