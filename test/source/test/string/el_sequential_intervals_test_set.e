note
	description: "Summary description for {EL_SEQUENTIAL_INTERVALS_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SEQUENTIAL_INTERVALS_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_item_count
		local
			str: ZSTRING; has_item_count_zero: BOOLEAN
			list: EL_SEQUENTIAL_INTERVALS
		do
			str := "A B  C"
			list := str.split_intervals (" ")
			assert ("count is 4", list.count = 4)
			from list.start until has_item_count_zero or list.after loop
				if list.item_count = 0 then
					has_item_count_zero := True
				end
				list.forth
			end
			assert ("has_item_count_zero", has_item_count_zero)
		end
end
