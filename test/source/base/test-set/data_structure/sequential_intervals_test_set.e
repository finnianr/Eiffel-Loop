note
	description: "Sequential intervals test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-25 9:13:31 GMT (Saturday 25th April 2020)"
	revision: "8"

class
	SEQUENTIAL_INTERVALS_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_ZSTRING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("item_count", agent test_item_count)
		end

feature -- Tests

	test_item_count
		local
			str: ZSTRING; has_item_count_zero: BOOLEAN
			list: EL_SEQUENTIAL_INTERVALS
		do
			str := "A B C "
			list := str.split_intervals (character_string (' '))
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
