note
	description: "Test objects conforming to [$source EL_POWER_2_BASE_NUMERIC_STRING_CONVERSION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-02 14:37:01 GMT (Friday 2nd December 2022)"
	revision: "1"

class
	POWER_2_BASE_NUMERIC_STRING_CONVERSION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("base_power_2_conversion", agent test_base_power_2_conversion)
		end

feature -- Conversion tests

	test_base_power_2_conversion
		note
			testing: "covers/{EL_READABLE_STRING_GENERAL_TO_TYPE}.new_type_description"
		local
			type_list: ARRAYED_LIST [STRING_GENERAL]; str: STRING_GENERAL
			b2: EL_BINARY_STRING_CONVERSION; b8: EL_OCTAL_STRING_CONVERSION
			b16: EL_HEXADECIMAL_STRING_CONVERSION
			n: INTEGER
		do
			create type_list.make_from_array (<<
				create {ZSTRING}.make (10),
				create {STRING}.make (10),
				create {STRING_32}.make (10)
			>>)
			across type_list as type loop
				across String_table as table loop
					str := type.item
					str.keep_head (0)
					str.append (table.key)
					lio.put_integer_field (str.generator + " base", table.item)
					lio.put_new_line
					inspect table.item
						when 2 then
							n := b2.to_integer (str)
						when 8 then
							n := b8.to_integer (str)
						when 16 then
							n := b16.to_integer (str)
					end
					assert ("expected value", n = 0xFF)
				end
			end
		end

feature {NONE} -- Implementation

	String_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			create Result.make (<<
				["11111111", 2],
				["0377", 8],
				["0xFF", 16]
			>>)
		end
end