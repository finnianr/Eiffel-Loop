note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	REFLECTION_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_default_tuple_initialization
		local
			country, country_2: STORABLE_COUNTRY
		do
			create country.make (new_value_table)
			assert ("temperature_range not void", attached country.temperature_range)
			assert ("unit_name.is_empty", country.temperature_range.unit_name.is_empty)

			create country_2.make (new_value_table)
			assert ("country is equal to country_2", country ~ country_2)
			country_2.temperature_range.unit_name := "Celcius"
			assert ("country not equal to country_2", country /~ country_2)
		end

	test_object_initialization_from_camel_case_table
		note
			testing: "covers/{EL_REFLECTIVELY_SETTABLE}.make_from_zkey_table, {EL_REFLECTIVELY_SETTABLE}.from_camel_case"
		local
			country: CAMEL_CASE_COUNTRY; table: like new_value_table
		do
			table := new_value_table
			table.replace_key ("LiteracyRate", "literacy_rate")
			create country.make (table)
			assert ("same name", country.name ~ Value_name)
			assert ("same code", country.code  ~ Value_ie.to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_literacy_rate.to_real)
			assert ("same population", country.population ~ Value_population.to_integer)
		end

	test_object_initialization_from_table
		note
			testing: "covers/{EL_REFLECTIVELY_SETTABLE}.make_from_zkey_table"
		local
			country: COUNTRY
		do
			create country.make (new_value_table)
			assert ("same name", country.name ~ Value_name)
			assert ("same code", country.code  ~ Value_ie.to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_literacy_rate.to_real)
			assert ("same population", country.population ~ Value_population.to_integer)
		end

feature {NONE} -- Implementation

	new_value_table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create Result.make (<<
				["code", Value_ie],
				["literacy_rate", Value_literacy_rate],
				["population", Value_population],
				["name", Value_name]
			>>)
		end

feature {NONE} -- Constants

	Value_data_1: ZSTRING
		once
			Result := "111"
		end

	Value_ie: ZSTRING
		once
			Result := "IE"
		end

	Value_literacy_rate: ZSTRING
		once
			Result := "0.9"
		end

	Value_name: ZSTRING
		once
			Result := "Ireland"
		end

	Value_population: ZSTRING
		once
			Result := "6500000"
		end

end
