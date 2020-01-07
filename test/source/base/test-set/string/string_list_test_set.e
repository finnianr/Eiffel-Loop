note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-25 10:50:08 GMT (Tuesday 25th December 2018)"
	revision: "3"

class
	STRING_LIST_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_split_and_join_1
		local
			split_numbers: EL_STRING_LIST [STRING]
		do
			create split_numbers.make_with_separator (Numbers, ',', False)
			assert ("same string", Numbers ~ split_numbers.joined (','))

			split_numbers := << "one", "two", "three" >>
			assert ("same string", Numbers ~ split_numbers.joined (','))
		end

	test_split_and_join_2
		local
			split_numbers: EL_SPLIT_ZSTRING_LIST
		do
			create split_numbers.make (Numbers, ",")
			assert ("same string", Numbers ~ split_numbers.joined (','))
		end

	test_path_split
		local
			split_path_8: LIST [STRING]
			split_path: EL_SPLIT_ZSTRING_LIST
		do
			split_path_8 := Unix_path.split ('/')
			create split_path.make (Unix_path, "/")
			assert (
				"all steps are equal",
				across split_path_8 as step all step.item ~ split_path.i_th (step.cursor_index).to_string_8 end
			)
		end

feature {NONE} -- Constants

	Numbers: STRING = "one,two,three"

	Unix_path: STRING = "/home/joe"
end
