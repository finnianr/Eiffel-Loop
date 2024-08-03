note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-03 8:51:23 GMT (Saturday 3rd August 2024)"
	revision: "55"

class
	REFLECTION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL; EL_MODULE_FACTORY

	EL_SHARED_CURRENCY_ENUM

	JSON_TEST_DATA; COUNTRY_TEST_DATA

	EL_REFLECTION_CONSTANTS

	EL_SHARED_FACTORIES; EL_SHARED_LOG_OPTION; EL_SHARED_HTTP_STATUS; EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["arrayed_list_initialization",						agent test_arrayed_list_initialization],
				["compactable_objects",									agent test_compactable_objects],
				["default_tuple_initialization",						agent test_default_tuple_initialization],
				["enumeration",											agent test_enumeration],
				["field_name_search_by_address",						agent test_field_name_search_by_address],
				["field_representation",								agent test_field_representation],
				["field_value_setter",									agent test_field_value_setter],
				["field_value_table",									agent test_field_value_table],
				["initialized_object_factory",						agent test_initialized_object_factory],
				["makeable_object_factory",							agent test_makeable_object_factory],
				["object_initialization_from_camel_case_table",	agent test_object_initialization_from_camel_case_table],
				["object_initialization_from_table",				agent test_object_initialization_from_table],
				["reflected_collection_factory",						agent test_reflected_collection_factory],
				["reflected_integer_list",								agent test_reflected_integer_list],
				["reflective_string_table",							agent test_reflective_string_table],
				["reflection",												agent test_reflection],
				["reflective_string_constants",						agent test_reflective_string_constants],
				["set_from_other",										agent test_set_from_other],
				["size_reporting",										agent test_size_reporting],
				["substituted_type_id",									agent test_substituted_type_id]
			>>)
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

	test_compactable_objects
		-- REFLECTION_TEST_SET.test_compactable_objects
		note
			testing: "[
				covers/{EL_REFLECTED_FIELD_BIT_MASKS}.make,
				covers/{EL_REFLECTIVE}.is_equal,
				covers/{EL_COMPACTABLE_REFLECTIVE}.make_by_compact,
				covers/{EL_COMPACTABLE_REFLECTIVE}.compact_value
			]"
		local
			date: COMPACTABLE_DATE; date_2: DATE; status, status_2: EL_FIREWALL_STATUS
			compact_64: NATURAL_64
		do
			create date.make (2005, 12, 30)
			create date_2.make (2005, 12, 30)
			assert ("same compact", date.compact_date.to_integer_32 = date_2.ordered_compact_date)

			date_2.set_date (2023, 11, 2)
			date.set_from_compact_date (date_2.ordered_compact_date)
			assert ("same year", date.year = date_2.year)
			assert ("same month", date.month = date_2.month)
			assert ("same day", date.day = date_2.day)

			create status
			status.set_date (date_2.ordered_compact_date)
			status.block (Service_port.http)

			compact_64 := (compact_64.one |<< 32).bit_or (date_2.ordered_compact_date.to_natural_64)
			assert ("compact_status OK", compact_64 = status.compact_status)

			create status_2.make_from_compact (status.compact_status)
			assert ("are equal", status ~ status_2)
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
					failed ("unit_name /= Void")
				end
			else
				failed ("temperature_range /= Void")
			end
		end

	test_enumeration
		-- REFLECTION_TEST_SET.test_enumeration
		note
			testing: "[
				covers/{EL_ENUMERATION}.description,
				covers/{EL_ENUMERATION}.has_field_name,
				covers/{EL_ENUMERATION}.field_name,
				covers/{EL_ENUMERATION}.value,
				covers/{EL_ENUMERATION}.field_name
			]"
		do
			if Http_status.valid_description_keys then
				assert_same_string (Void, Http_status.description (Http_status.continue), "Client can continue.")
			else
				failed ("valid_description_keys")
			end
			assert_same_string ("404 is not found", Http_status.field_name (404), "not_found")
			assert_same_string ("404 is not found", Http_status.name (404), "Not found")
			assert ("Not found = 404", Http_status.value ("Not found") = 404)
			if Http_status.has_field_name ("not_found") then
				assert ("is 404", Http_status.found_value = 404)
			else
				failed ("has_field_name")
			end
		end

	test_field_name_search_by_address
		-- REFLECTION_TEST_SET.test_field_name_search_by_address
		note
			testing: "covers/{EL_FIELD_TABLE}.has_address"
		do
			assert_same_string (Void, "logging", Log_option.Name_logging)
		end

	test_field_representation
		local
			representation: EL_ENUMERATION_REPRESENTATION [NATURAL_8]
		do
			representation := Currency_enum.to_representation
			assert ("EURO is 9", representation.to_value ("EUR") = (9).to_natural_8)
		end

	test_field_value_setter
		-- REFLECTION_TEST_SET.test_field_value_setter
		local
			string_setter: EL_FIELD_TYPE_QUERY [STRING]
		do
			if attached new_country as country then
				create string_setter.make (country, False)
				string_setter.set_values (country, agent to_upper, True)
				assert ("upper code", country.code ~ "CODE")
				assert ("upper continent", country.continent ~ "CONTINENT")
			end
		end

	test_field_value_table
		-- REFLECTION_TEST_SET.test_field_value_table
		local
			string_table: EL_FIELD_VALUE_TABLE [STRING]
			integer_table: EL_FIELD_VALUE_TABLE [INTEGER]

			string_values: ARRAY [TUPLE [name, value: STRING]]
			integer_values: ARRAY [TUPLE [name: STRING; value: INTEGER]]
		do
			if attached new_country as country then
				create string_table.make (country)
				string_values := << ["code", "IE"], ["continent", "Europe"] >>
				assert ("same field count", string_table.count = string_values.count)
				across string_values as list loop
					if string_table.has_key (list.item.name) then
						assert ("expected value", string_table.found_item ~ list.item.value)
					else
						failed ("has name " + list.item.name)
					end
				end
				create integer_table.make (country)
				integer_values := << ["population", country.population], ["date_founded", country.date_founded] >>
				assert ("same field count", integer_table.count = integer_values.count)
				across integer_values as list loop
					if integer_table.has_key (list.item.name) then
						assert ("expected value", integer_table.found_item ~ list.item.value)
					else
						failed ("has name " + list.item.name)
					end
				end
			end
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
					failed ("created")
				end
			end
			if attached Default_factory.new_item_from_type ({BOOLEAN_REF}) as bool then
				lio.put_labeled_string ("Created", bool.generator)
				lio.put_new_line
				assert ("same type", bool.generating_type ~ {BOOLEAN_REF})
			else
				failed ("created BOOLEAN_REF")
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
					failed ("created " + list.item.name)
				end
			end
		end

	test_makeable_object_factory
		-- REFLECTION_TEST_SET.test_makeable_object_factory
		local
			f: EL_MAKEABLE_OBJECT_FACTORY; type: TYPE [COLUMN_VECTOR_COMPLEX_64]
		do
			create f
			type := {COLUMN_VECTOR_COMPLEX_64}
			if attached {COLUMN_VECTOR_COMPLEX_64} f.new_item_from_name (type.name) as vector then
				assert_same_string (Void, type.name, vector.generator)
			else
				failed ("vector created")
			end
		end

	test_object_initialization_from_camel_case_table
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.make_from_table, covers/{EL_CAMEL_CASE_TRANSLATER}.imported"
		local
			country: CAMEL_CASE_COUNTRY; table: like Country_table
		do
			create table.make_size (Country_table.count)
			table.merge (Country_table)
			table.replace_key ("literacyRate", "literacy_rate")
			table.replace_key ("photoJpeg", "photo_jpeg")
			table.replace_key ("euroZoneMember", "euro_zone_member")
			create country.make (table)
			country.province_list.copy (new_country.province_list)
			check_values (country)
		end

	test_object_initialization_from_table
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.make_from_table"
		do
			check_values (new_country)
		end

	test_reflected_collection_factory
		-- REFLECTION_TEST_SET.test_reflected_collection_factory
		local
			type_list: ARRAY [TYPE [ANY]]; type_id: INTEGER; factory_type: TYPE [ANY]
			integer_factory: EL_REFLECTED_COLLECTION_FACTORY [INTEGER, EL_REFLECTED_COLLECTION [INTEGER]]
		do
			create integer_factory -- {INTEGER} will fail without this

			type_list := << {INTEGER}, {STRING}, {COUNTRY} >>
			across type_list as type loop
				if attached Collection_field_factory_factory.new_item_factory (type.item.type_id) as factory_item then
					lio.put_labeled_string ("Created", factory_item.generating_type.name)
					lio.put_new_line
				else
					type_id := Factory.substituted_type_id (
						{EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]]}, {ANY}, type.item.type_id
					)
					lio.put_labeled_string ("Failed to create",  {ISE_RUNTIME}.generating_type_of_type (type_id))
					lio.put_new_line
					failed ("created factory")
				end
			end
		end

	test_reflected_integer_list
		local
			l_test: TEST_STORABLE
		do
			create l_test.make_default
			assert ("integer_list initialized", attached l_test.integer_list)
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

	test_reflective_string_table
		-- REFLECTION_TEST_SET.test_reflective_string_table
		note
			testing: "[
				covers/{EL_STRING_ITERATION_CURSOR}.occurrences_in_bounds,
				covers/{EL_TABLE_INTERVAL_MAP_LIST}.make,
				covers/{EL_REFLECTIVE_STRING_TABLE}.make,
				covers/{EL_SUB}.count,
				covers/{EL_SUB}.lines
			]"
		local
			table: HTTP_STATUS_TABLE
		do
			create table.make_default
			assert_same_http_status (table.ok, Http_status.ok)
			assert_same_http_status (table.found, Http_status.found)
			assert_same_http_status (table.continue, Http_status.continue)
			assert_same_http_status (table.not_acceptable, Http_status.not_acceptable)

		end

	test_set_from_other
		-- REFLECTION_TEST_SET.test_set_from_other
		note
			testing: "covers/{EL_REFLECTIVE}.set_from_other"
		local
			country: COUNTRY; country_2: COUNTRY
		do
			country := new_country
			create country_2.make_default
			country_2.set_from_other (country, "continent, population")
			assert ("continent is empty", country_2.continent.is_empty)
			assert ("population is zero", country_2.population = 0)
			country_2.set_continent (Country_table ["continent"])
			country_2.set_population (Country_table ["population"].to_integer)
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

	test_substituted_type_id
		note
			testing: "covers/{EL_INTERNAL}.substituted_type_id"
		local
			type_id: INTEGER
		do
			type_id := Factory.substituted_type_id ({EL_MAKEABLE_FACTORY [EL_MAKEABLE]}, {EL_MAKEABLE}, ({EL_UUID}).type_id)
			assert_same_string (Void, {ISE_RUNTIME}.generating_type_of_type (type_id), "EL_MAKEABLE_FACTORY [EL_UUID]")
		end

feature {NONE} -- Implementation

	to_upper (name: READABLE_STRING_8): STRING
		do
			Result := name
			Result.to_upper
		end

feature {NONE} -- Constants

	assert_same_http_status (status: EL_SUBSTRING_8; status_code: NATURAL_16)
		local
			string, code_string: STRING; code: NATURAL_16; s: EL_STRING_8_ROUTINES
		do
			string := status
			code_string := s.substring_to (string, ' ')
			string.remove_head (code_string.count + 1)
			assert ("same status code", code_string.to_natural_16 = status_code)
			if attached Http_status.description (status_code) as description then
				assert ("same count", status.count - code_string.count - 1 = description.count)
				assert_same_string ("same description", string, description)
			end
		end

	Immutable_string_8: IMMUTABLE_STRING_8
		once
			Result := "immutable_string_8"
		end

	Object_header_size: INTEGER = 16

	Reflected_collection_factory_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]], EL_REFLECTED_COLLECTION [ANY]
	]
		once
			create Result
		end

	String_8: STRING_8 = "string_8"

end