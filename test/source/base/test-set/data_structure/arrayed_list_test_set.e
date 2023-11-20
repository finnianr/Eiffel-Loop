note
	description: "Arrayed list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-20 19:02:00 GMT (Monday 20th November 2023)"
	revision: "12"

class
	ARRAYED_LIST_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["arrayed_representation_list", agent test_arrayed_representation_list],
				["shift",							  agent test_shift]
			>>)
		end

feature -- Tests

	test_arrayed_representation_list
		-- ARRAYED_LIST_TEST_SET.test_arrayed_representation_list
		local
			date_list: DATE_LIST; d1, d2: DATE
			date_array: ARRAY [DATE]
		do
			create d1.make (2022, 1, 1); create d2.make (2022, 12, 31)
			date_array := << d1, d2 >>
			create date_list.make (2)
			date_list.extend (d1)
			date_list.extend_seed (d2.ordered_compact_date)

			assert ("two items", date_list.count = 2)
			across date_list as list loop
				assert ("same item", list.item ~ date_array [list.cursor_index])
			end
			if attached date_list as list then
				from list.start until list.after loop
					assert ("same item", list.item ~ date_array [list.index])
					list.forth
				end
			end

		end

	test_shift
		local
			list: EL_ARRAYED_LIST [CHARACTER]
		do
			create list.make_from_array (<< 'a', 'b', 'c', 'd' >>)
			list.shift_i_th (2, 2)
			assert ("b shifted right by 2", to_string (list) ~ "acdb")
			list.shift_i_th (4, -3)
			assert ("b shifted left by 3", to_string (list) ~ "bacd")
			list.shift_i_th (1, 1)
			assert ("b shifted right by 1", to_string (list) ~ "abcd")
		end

feature {NONE} -- Implementation

	to_string (list: EL_ARRAYED_LIST [CHARACTER]): STRING
		do
			create Result.make (list.count)
			list.do_all (agent Result.extend)
		end
end