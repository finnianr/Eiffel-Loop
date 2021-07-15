note
	description: "Test [$source EL_DOCUMENT_NODE_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-14 9:46:24 GMT (Wednesday 14th July 2021)"
	revision: "3"

class
	DOCUMENT_NODE_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
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
			across << Dollor_symbol, Euro_symbol >> as symbol loop
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

feature {NONE} -- Constants

	Dollor_symbol: CHARACTER_32 = '$'

	Euro_symbol: CHARACTER_32 = '€'
end