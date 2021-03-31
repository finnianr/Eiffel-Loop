note
	description: "Hash table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-31 15:02:23 GMT (Wednesday 31st March 2021)"
	revision: "1"

class
	HASH_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("iteration_cursor", agent test_iteration_cursor)
		end

feature -- Test

	test_iteration_cursor
		local
			table: EL_HASH_TABLE [INTEGER, INTEGER]
			list: ARRAYED_LIST [INTEGER]; step, value, index: INTEGER
		do
			create table.make_equal (10)
			create list.make (10)
			across 0 |..| 9 as n loop
				table.extend (n.item, n.item)
			end
			across 3 |..| 5 as key loop
				table.remove (key.item)
				across 1 |..| 4 as n loop
					step := n.item
					list.wipe_out
					across table.new_cursor + step as t loop
						value := t.item; index := t.cursor_index
						list.extend (value)
						assert ("same item", list [index] = list.last)
					end
				end
			end
		end
end