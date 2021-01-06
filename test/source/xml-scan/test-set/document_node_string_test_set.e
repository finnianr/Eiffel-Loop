note
	description: "Test [$source EL_DOCUMENT_NODE_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-06 17:43:49 GMT (Wednesday 6th January 2021)"
	revision: "1"

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
			create node.make_empty
			across << Dollor_symbol, Euro_symbol >> as symbol loop
				padded [2] := symbol.item
				node.set_from_general (padded)
				str := node.to_string
				assert ("valid count", str.count = 1)
				assert ("valid str", str [1] = symbol.item)

				str_32 := node.to_string_32
				assert ("valid count", str_32.count = 1)
				assert ("valid str", str_32 [1] = symbol.item)
			end
		end

feature {NONE} -- Constants

	Dollor_symbol: CHARACTER_32 = '$'

	Euro_symbol: CHARACTER_32 = '€'
end