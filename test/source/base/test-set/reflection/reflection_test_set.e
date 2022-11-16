note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "31"

class
	REFLECTION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL

	EL_MODULE_TUPLE

	EL_MODULE_LIO

	EL_SHARED_CURRENCY_ENUM

	EL_MODULE_BASE_64

	JSON_TEST_DATA

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("arrayed_list_initialization", agent test_arrayed_list_initialization)
			eval.call ("default_tuple_initialization", agent test_default_tuple_initialization)
			eval.call ("field_representation", agent test_field_representation)
			eval.call ("object_initialization_from_camel_case_table", agent test_object_initialization_from_camel_case_table)
			eval.call ("object_initialization_from_table", agent test_object_initialization_from_table)
			eval.call ("reflection", agent test_reflection)
			eval.call ("reflective_string_constants", agent test_reflective_string_constants)
			eval.call ("set_from_other", agent test_set_from_other)
			eval.call ("size_reporting", agent test_size_reporting)
		end

feature -- Tests

	test_arrayed_list_initialization
		local
			any_list: ARRAYED_LIST [ANY]; integer_list: EL_ARRAYED_LIST [INTEGER]
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

	test_field_representation
		local
			representation: EL_ENUMERATION_REPRESENTATION [NATURAL_8]
		do
			representation := Currency_enum.to_representation
			assert ("EURO is 9", representation.to_value ("EUR") = (9).to_natural_8)
		end

	test_object_initialization_from_camel_case_table
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.make_from_table, covers/{EL_CAMEL_CASE_TRANSLATER}.imported"
		local
			country: CAMEL_CASE_COUNTRY; table: like Value_table
		do
			create table.make_with_count (Value_table.count)
			table.merge (Value_table)
			table.replace_key ("literacyRate", "literacy_rate")
			table.replace_key ("photoJpeg", "photo_jpeg")
			table.replace_key ("euroZoneMember", "euro_zone_member")
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

	test_reflective_string_constants
		local
			name: NAME_CONSTANTS
		do
			create name
			assert ("equal strings", name.string_8 ~ String_8)
			assert ("equal strings", name.immutable_string_8 ~ Immutable_string_8)
		end

	test_set_from_other
		note
			testing: "covers/{EL_REFLECTIVE}.set_from_other"
		local
			country: COUNTRY; country_2: STORABLE_COUNTRY
		do
			create country.make (Value_table)
			create country_2.make_default
			country_2.set_from_other (country, "continent, population")
			assert ("continent is empty", country_2.continent.is_empty)
			assert ("population is zero", country_2.population = 0)
			country_2.set_continent (Value_table ["continent"])
			country_2.set_population (Value_table ["population"].to_integer)
			check_values (country_2)

			create country_2.make_default
			country_2.set_from_other (country, Void)
			check_values (country_2)
		end

	test_size_reporting
		local
			geo_info: EL_IP_ADDRESS_GEOGRAPHIC_INFO
			asn_string: EL_CODE_STRING; n_64: INTEGER_64; l_info: SIZE_TEST
		do
			create geo_info.make_from_json (JSON_eiffel_loop_ip)

			lio.put_integer_field ("size of INTEGER_64", {PLATFORM}.Integer_64_bytes)
			lio.put_new_line
			asn_string := geo_info.asn_
			lio.put_integer_field ("size of EL_CODE_STRING " + asn_string, Eiffel.deep_physical_size (asn_string))
			lio.put_new_line
			assert ("12 times bigger", Eiffel.deep_physical_size (asn_string) // {PLATFORM}.Integer_64_bytes = 12)

			create l_info
			lio.put_integer_field ("size of instance SIZE_TEST", Eiffel.deep_physical_size (l_info))
			lio.put_new_line

			assert ("same size", Eiffel.deep_physical_size (l_info) = Object_header_size + {PLATFORM}.Integer_64_bytes * 4)
		end

feature {NONE} -- Implementation

	check_values (country: COUNTRY)
		local
			name: ZSTRING; date_founded: DATE; euro_zone_member: BOOLEAN
			photo_jpeg: MANAGED_POINTER
		do
			name := Value_table.item (Field.name)
			assert ("same name", country.name ~ name)
			assert ("same code", country.code  ~ Value_table.item (Field.code).to_string_8)
			lio.put_labeled_string ("country.currency_name", country.currency_name)
			lio.put_new_line
			assert ("same currency", country.currency_name  ~ Value_table.item (Field.currency).to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_table.item (Field.literacy_rate).to_real)
			assert ("same population", country.population ~ Value_table.item (Field.population).to_integer)

			-- Test field cached in associated set
			assert ("same continent", country.continent ~ Value_table.item (Field.continent).to_string_8)
			assert ("in continent set", across country.Continent_set as list some list.item = country.continent end)

			create date_founded.make_from_string_default (Value_table.item (Field.date_founded))
			assert ("same date_founded", country.date_founded = date_founded.ordered_compact_date)
			euro_zone_member := Value_table.item (Field.euro_zone_member) ~ "YES"
			assert ("same euro_zone_member", country.euro_zone_member = euro_zone_member)

			create photo_jpeg.make_from_array (Base_64.decoded_array (Value_table.item (Field.photo_jpeg)))
			assert ("same photo", country.photo_jpeg ~ photo_jpeg)
		end

feature {NONE} -- Constants

	Field: TUPLE [
		code, continent, currency, date_founded, euro_zone_member, literacy_rate, name, photo_jpeg, population: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"code, continent, currency, date_founded, euro_zone_member, literacy_rate, name, photo_jpeg, population"
			)
		end

	Immutable_string_8: IMMUTABLE_STRING_8
		once
			Result := "immutable_string_8"
		end

	Object_header_size: INTEGER = 16

	String_8: STRING_8 = "string_8"

	Value_table: EL_ZSTRING_TABLE
		once
			create Result.make ("[
				code:
					IE
				continent:
					Europe
				currency:
					EUR
				date_founded:
					12/29/1937
				literacy_rate:
					0.9
				name:
					Ireland
				population:
					6500000
				photo_jpeg:
					VyDHQ26RoAdUlNMQiWOKp22iUZEbS/VqWgX6rafZUGg=
				euro_zone_member:
					YES
			]")
		end

end