note
	description: "Summary description for {RELFECTION_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 13:57:38 GMT (Wednesday 6th December 2017)"
	revision: "2"

class
	REFLECTION_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_object_initialization_from_table
		note
			testing: "covers/{EL_REFLECTIVELY_SETTABLE}.make_from_zkey_table"
		local
			country: COUNTRY; table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create table.make (<<
				["code", Value_ie],
				["literacy_rate", Value_literacy_rate],
				["population", Value_population],
				["name", Value_name]
			>>)
			create country.make (table)
			assert ("same name", country.name ~ Value_name)
			assert ("same code", country.code  ~ Value_ie.to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_literacy_rate.to_real)
			assert ("same population", country.population ~ Value_population.to_integer)
		end

	test_object_initialization_from_camel_case_table
		note
			testing: "covers/{EL_REFLECTIVELY_SETTABLE}.make_from_zkey_table, {EL_REFLECTIVELY_SETTABLE}.from_camel_case"
		local
			country: CAMEL_CASE_COUNTRY; table: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create table.make (<<
				["code", Value_ie],
				["LiteracyRate", Value_literacy_rate],
				["population", Value_population],
				["name", Value_name]
			>>)
			create country.make (table)
			assert ("same name", country.name ~ Value_name)
			assert ("same code", country.code  ~ Value_ie.to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_literacy_rate.to_real)
			assert ("same population", country.population ~ Value_population.to_integer)
		end

feature {NONE} -- Implementation


feature {NONE} -- Constants

	Value_ie: ZSTRING
		once
			Result := "IE"
		end

	Value_name: ZSTRING
		once
			Result := "Ireland"
		end

	Value_literacy_rate: ZSTRING
		once
			Result := "0.9"
		end

	Value_population: ZSTRING
		once
			Result := "6500000"
		end

	Value_data_1: ZSTRING
		once
			Result := "111"
		end

end
