note
	description: "Test [$source EL_DOCUMENT_NODE_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	DOCUMENT_NODE_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("adjusted_strings", agent test_adjusted_strings)
		end

feature -- Conversion tests

	test_adjusted_strings
		local
			padded, str_32: STRING_32; node: EL_DOCUMENT_NODE_STRING
			str: ZSTRING
		do
			create padded.make_filled (' ', 3)
			create node.make_default
			across << Text.Dollor_symbol, Text.Euro_symbol >> as symbol loop
				padded [2] := symbol.item
				node.set_from_general (padded)
				check_string (node.to_string, symbol.item, 1, 1)
				check_string (node.to_string_32, symbol.item, 1, 1)
				check_string (node.raw_string (True), symbol.item, 2, 3)
				check_string (node.raw_string_32 (True), symbol.item, 2, 3)
			end
		end

feature {NONE} -- Implementation

	check_string (str: READABLE_STRING_GENERAL; symbol: CHARACTER_32; index, count: INTEGER)
		do
			assert ("valid count", str.count = count)
			assert ("valid str", str [index] = symbol)
		end

end