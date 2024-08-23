note
	description: "[
		Test objects conforming to ${EL_BASE_POWER_2_CONVERTER}

			EL_BASE_POWER_2_CONVERTER*
				${EL_OCTAL_CONVERTER}
				${EL_BINARY_CONVERTER}
				${EL_HEXADECIMAL_CONVERTER}

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-23 14:58:11 GMT (Friday 23rd August 2024)"
	revision: "10"

class
	BASE_POWER_2_CONVERTER_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["base_power_2_conversion", agent test_base_power_2_conversion]
			>>)
		end

feature -- Conversion tests

	test_base_power_2_conversion
		note
			testing: "covers/{EL_READABLE_STRING_GENERAL_TO_TYPE}.new_type_description"
		local
			type_list: ARRAYED_LIST [STRING_GENERAL]; str: STRING_GENERAL
			b2: EL_BINARY_CONVERTER; b8: EL_OCTAL_CONVERTER; b16: EL_HEXADECIMAL_CONVERTER
			n: INTEGER
		do
			create type_list.make_from_array (<<
				create {ZSTRING}.make (10), create {STRING}.make (10), create {STRING_32}.make (10)
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