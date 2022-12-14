note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-13 9:10:50 GMT (Tuesday 13th December 2022)"
	revision: "35"

class
	REFLECTION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL; EL_MODULE_LIO

	EL_SHARED_CURRENCY_ENUM

	JSON_TEST_DATA; STORABLE_COUNTRY_TEST_DATA

	EL_REFLECTION_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("arrayed_list_initialization", agent test_arrayed_list_initialization)
			eval.call ("default_tuple_initialization", agent test_default_tuple_initialization)
			eval.call ("field_representation", agent test_field_representation)
			eval.call ("initialized_object_factory", agent test_initialized_object_factory)
			eval.call ("object_initialization_from_camel_case_table", agent test_object_initialization_from_camel_case_table)
			eval.call ("object_initialization_from_table", agent test_object_initialization_from_table)
			eval.call ("reflected_collection_factory", agent test_reflected_collection_factory)
			eval.call ("reference_field_list", agent test_reference_field_list)
			eval.call ("reflection", agent test_reflection)
			eval.call ("reflective_string_constants", agent test_reflective_string_constants)
			eval.call ("set_from_other", agent test_set_from_other)
			eval.call ("size_reporting", agent test_size_reporting)
			eval.call ("substituted_type_name", agent test_substituted_type_name)
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
			country: COUNTRY
		do
			create country.make_default
			if attached country.temperature_range as temperature_range then
				if attached temperature_range.unit_name as unit_name then
					assert ("unit_name.is_empty", unit_name.is_empty)
				else
					assert ("unit_name /= Void", False)
				end
			else
				assert ("temperature_range /= Void", False)
			end
		end

	test_field_representation
		local
			representation: EL_ENUMERATION_REPRESENTATION [NATURAL_8]
		do
			representation := Currency_enum.to_representation
			assert ("EURO is 9", representation.to_value ("EUR") = (9).to_natural_8)
		end

	test_initialized_object_factory
		-- GENERAL_TEST_SET.test_initialized_object_factory
		note
			testing: "covers/{EL_INITIALIZED_OBJECT_FACTORY}.new_item_from_type"
		local
			type_list: ARRAYED_LIST [TYPE [READABLE_STRING_GENERAL]]
			arrayed_type_list: ARRAYED_LIST [TYPE [ARRAYED_LIST [ANY]]]
		do
			create type_list.make_from_array (<<
				{IMMUTABLE_STRING_32}, {IMMUTABLE_STRING_8},
				{STRING_32}, {STRING_8}, {EL_STRING_32}, {EL_STRING_8},
				{ZSTRING}
			>>)
			across type_list as list loop
				if attached String_factory.new_item_from_type (list.item) as str then
					lio.put_labeled_string ("Created", str.generator)
					lio.put_new_line
					assert ("same type", str.generating_type ~ list.item)
				else
					assert ("created", False)
				end
			end
			if attached Default_factory.new_item_from_type ({BOOLEAN_REF}) as bool then
				lio.put_labeled_string ("Created", bool.generator)
				lio.put_new_line
				assert ("same type", bool.generating_type ~ {BOOLEAN_REF})
			else
				assert ("created BOOLEAN_REF", False)
			end
			create arrayed_type_list.make_from_array (<<
				{ARRAYED_LIST [STRING]}, {EL_STRING_8_LIST}, {EL_ARRAYED_LIST [INTEGER]}
			>>)
			across arrayed_type_list as list loop
				if attached Arrayed_list_factory.new_item_from_type (list.item) as new then
					lio.put_labeled_string ("Created", new.generator)
					lio.put_new_line
					assert ("same type", new.generating_type ~ list.item)
				else
					assert ("created " + list.item.name, False)
				end
			end
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

	test_reference_field_list
		-- REFLECTION_TEST_SET.test_reference_field_list
		do
			across Reference_field_list as list loop
				lio.put_line (list.item.value_type.name)
			end
		end

	test_reflected_collection_factory
		local
			factory: EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]]
		do
			factory := Reflected_collection_factory.new_item_factory (({ARRAYED_LIST [STRING]}).type_id)
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

	test_substituted_type_name
		note
			testing: "covers/{EL_INTERNAL}.substituted_type_name"
		local
			type_name: STRING
		do
			type_name := Eiffel.substituted_type_name ({EL_MAKEABLE_FACTORY [EL_MAKEABLE]}, {EL_MAKEABLE}, {EL_UUID})
			assert ("same string", type_name ~ "EL_MAKEABLE_FACTORY [EL_UUID]")
		end

feature {NONE} -- Constants

	Immutable_string_8: IMMUTABLE_STRING_8
		once
			Result := "immutable_string_8"
		end

	Object_header_size: INTEGER = 16

	Reflected_collection_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]], EL_REFLECTED_COLLECTION [ANY]
	]
		once
			create Result
		end

	String_8: STRING_8 = "string_8"

end