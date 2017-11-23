note
	description: "Summary description for {STRING_LIST_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

feature {NONE} -- Constants

	Numbers: STRING = "one,two,three"
end
