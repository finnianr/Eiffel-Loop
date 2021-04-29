note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-29 12:39:18 GMT (Thursday 29th April 2021)"
	revision: "12"

class
	REFLECTION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("default_tuple_initialization", agent test_default_tuple_initialization)
--			eval.call ("arrayed_list_initialization", agent test_arrayed_list_initialization)
			eval.call ("object_initialization_from_camel_case_table", agent test_object_initialization_from_camel_case_table)
			eval.call ("object_initialization_from_table", agent test_object_initialization_from_table)
			eval.call ("reflection", agent test_reflection)
		end

feature -- Tests

	test_arrayed_list_initialization
		local
			any_list: ARRAYED_LIST [ANY]
			integer_list: EL_ARRAYED_LIST [INTEGER]
		do
			create integer_list.make (0)
			any_list := integer_list
			assert ("zero count", any_list.count = 0)
		end

	test_default_tuple_initialization
		local
			country, country_2: STORABLE_COUNTRY
		do
			create country.make (Value_table)
			assert ("temperature_range not void", attached country.temperature_range)
			assert ("unit_name.is_empty", country.temperature_range.unit_name.is_empty)

			create country_2.make (Value_table)
			assert ("country is equal to country_2", country ~ country_2)
			country_2.temperature_range.unit_name := "Celcius"
			assert ("country not equal to country_2", country /~ country_2)
		end

	test_object_initialization_from_camel_case_table
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.make_from_table, covers/{EL_WORD_SEPARATION_ADAPTER}.from_camel_case"
		local
			country: CAMEL_CASE_COUNTRY; table: like Value_table
		do
			create table.make_with_count (Value_table.count)
			table.merge (Value_table)
			table.replace_key ("LiteracyRate", "literacy_rate")
			create country.make (table)
			check_values (country)
		end

	test_object_initialization_from_table
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.make_from_table"
		local
			country: COUNTRY
		do
			create country.make (Value_table)
			check_values (country)
		end

	test_reflection
		local
			table: HASH_TABLE [STRING_32, STRING]
			object: MY_DRY_CLASS
		do
			create object.make_default
			create table.make_equal (object.field_table.count)
			across object.field_table as l_field loop
				if l_field.key ~ "boolean" then
					table [l_field.key] := "True"
				else
					table [l_field.key] := l_field.cursor_index.out
				end
			end
			create object.make (table)
			assert ("table ~ object.data_export", table ~ object.data_export)
		end

feature {NONE} -- Implementation

	check_values (country: COUNTRY)
		local
			name: ZSTRING
		do
			name := Value_table.item (Field.name)
			assert ("same name", country.name ~ name)
			assert ("same code", country.code  ~ Value_table.item (Field.code).to_string_8)
			assert ("same currency", country.currency_name  ~ Value_table.item (Field.currency).to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_table.item (Field.literacy_rate).to_real)
			assert ("same population", country.population ~ Value_table.item (Field.population).to_integer)
		end

feature {NONE} -- Constants

	Field: TUPLE [code, currency, literacy_rate, name, population: STRING]
		once
			create Result
			Tuple.fill (Result, "code, currency, literacy_rate, name, population")
		end

	Value_table: EL_ZSTRING_TABLE
		once
			create Result.make ("[
				code:
					IE
				currency:
					EUR
				literacy_rate:
					0.9
				name:
					Ireland
				population:
					6500000
			]")
		end

end