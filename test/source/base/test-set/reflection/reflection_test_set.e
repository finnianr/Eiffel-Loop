note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-03 16:51:39 GMT (Thursday 3rd October 2024)"
	revision: "70"

class
	REFLECTION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EIFFEL; EL_MODULE_FACTORY; EL_MODULE_EXECUTABLE

	EL_SHARED_CURRENCY_ENUM

	JSON_TEST_DATA; COUNTRY_TEST_DATA

	EL_REFLECTION_CONSTANTS

	EL_SHARED_CURRENCY_ENUM; EL_SHARED_FACTORIES; EL_SHARED_LOG_OPTION; EL_SHARED_HTTP_STATUS
	EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["arrayed_list_initialization",		  agent test_arrayed_list_initialization],
				["compactable_objects",					  agent test_compactable_objects],
				["default_tuple_initialization",		  agent test_default_tuple_initialization],
				["enumeration",							  agent test_enumeration],
				["field_name_search_by_address",		  agent test_field_name_search_by_address],
				["field_representation",				  agent test_field_representation],
				["field_value_reset",					  agent test_field_value_reset],
				["field_value_setter",					  agent test_field_value_setter],
				["field_value_table",					  agent test_field_value_table],
				["http_headers",							  agent test_http_headers],
				["initialized_object_factory",		  agent test_initialized_object_factory],
				["make_object_from_camel_case_table", agent test_make_object_from_camel_case_table],
				["make_object_from_table",				  agent test_make_object_from_table],
				["makeable_object_factory",			  agent test_makeable_object_factory],
				["new_parameterized_item",				  agent test_new_parameterized_item],
				["parameterized_type_id",				  agent test_parameterized_type_id],
				["reflected_collection_factory",		  agent test_reflected_collection_factory],
				["reflected_integer_list",				  agent test_reflected_integer_list],
				["reflection",								  agent test_reflection],
				["reflective_string_constants",		  agent test_reflective_string_constants],
				["reflective_string_table",			  agent test_reflective_string_table],
				["set_from_other",						  agent test_set_from_other],
				["size_reporting",						  agent test_size_reporting],
				["substituted_type_id",					  agent test_substituted_type_id],
				["value_list",								  agent test_value_list]
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
				covers/{EL_ENUMERATION}.as_list,
				covers/{EL_ENUMERATION}.description,
				covers/{EL_ENUMERATION}.name,
				covers/{EL_ENUMERATION}.field_name,
				covers/{EL_ENUMERATION}.has_field_name,
				covers/{EL_ENUMERATION}.value
			]"
		local
			string_encoding: TL_STRING_ENCODING_ENUM
		do
			if Http_status.valid_description_keys then
				assert_same_string (Void, Http_status.description (Http_status.continue), "Client can continue.")
			else
				failed ("valid_description_keys")
			end
		-- `Http_status' using `field_by_value_array'
			assert_same_string ("404 is not found", Http_status.field_name (404), "not_found")
			assert_same_string ("404 is not found", Http_status.name (404), "Not found")
			assert ("Not found = 404", Http_status.value ("Not found") = 404)
			if Http_status.has_field_name ("not_found") then
				assert ("is 404", Http_status.found_value = 404)
			else
				failed ("has_field_name")
			end
			if attached Http_status.as_list as list then
				assert ("first is 100", list.first.to_integer_32 = 100)
				assert ("last is 510", list.last.to_integer_32 = 510)
			end
		-- `Currency_enum' using `field_by_value_array'
			assert_same_string (Void, Currency_enum.name (Currency_enum.EUR), "EUR")
			assert_same_string (Void, Currency_enum.field_name (Currency_enum.EUR), "eur")
			if attached Currency_enum.as_list as list then
				assert ("first is AUD", list.first = Currency_enum.AUD)
				assert ("last is ZAR", list.last = Currency_enum.ZAR)
			end

		-- Class `TL_STRING_ENCODING_ENUM' using `field_by_value_array' (non-continuous array)
			create string_encoding.make
			if attached string_encoding.as_list as list then
				assert ("first is latin_1", list.first = string_encoding.latin_1)
				assert ("last is utf_16_little_endian", list.last = string_encoding.utf_16_little_endian)
				assert_same_string (Void,
					string_encoding.name (string_encoding.utf_16_little_endian), "UTF 16 little endian"
				)
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

	test_field_value_reset
		-- REFLECTION_TEST_SET.test_field_value_reset
		note
			testing: "[
				covers/{EL_REFLECTIVE}.reset_fields,
				covers/{EL_REFLECTED_FIELD}.reset,
				covers/{EL_TUPLE_ROUTINES}.reset
			]"
		local
			country: COUNTRY; string_fields: ARRAY [READABLE_STRING_GENERAL]
		do
			across new_country_list as list loop
				country := list.item
				country.reset_fields
				assert ("false booleans",
					across << country.brics_member.item, country.euro_zone_member >> as boolean all
						not boolean.item
					end
				)
				assert ("0 integers",
					across << country.date_founded, country.population >> as integer all
						integer.item = 0
					end
				)
				string_fields := << country.continent, country.name, country.code, country.wikipedia_url >>
				assert ("empty strings",
					across string_fields as string all
						string.item.is_empty
					end
				)
				assert ("currency is 0", country.currency = 0)
				assert ("empty pointer", country.photo_jpeg.count = 0)
				assert ("empty province_list", country.province_list.count = 0)
				if attached country.temperature_range as range then
					assert ("0 integers",
						across << range.winter, range.summer >> as integer all
							integer.item = 0
						end
					)
					assert ("empty unit_name", range.unit_name.count = 0)
				end
			end
		end

	test_field_value_setter
		-- REFLECTION_TEST_SET.test_field_value_setter
		local
			string_setter: EL_FIELD_TYPE_QUERY [STRING]
		do
			if attached new_country (Ireland) as country then
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
			if attached new_country (Ireland) as country then
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

	test_http_headers
		-- REFLECTION_TEST_SET.test_http_headers
		local
			header: EL_HTTP_HEADERS; nvp: EL_NAME_VALUE_PAIR [STRING]
			counter: EL_NATURAL_32_COUNTER
		do
			create header.make (Header_response)
			create counter
			across Header_response.split ('%N') as line loop
				if line.item [1] = 'H' then
					assert ("response OK", header.response_code = 200)
					assert_same_string ("is UTF-8", header.encoding_name, "UTF-8")
					counter.bump
				else
					create nvp.make (line.item, ':')
					inspect line.item [1]
						when 'D' then
							assert_same_string (Void, nvp.value, header.date)
							counter.bump
						when 'C' then
							if nvp.value.is_natural then
								assert ("length OK", nvp.value.to_integer = header.content_length)
								counter.bump
							else
								assert_same_string (Void, nvp.value, header.content_type)
								counter.bump
							end
						when 'L' then
							assert_same_string (Void, nvp.value, header.last_modified)
							counter.bump
						when 'S' then
							assert_same_string (Void, nvp.value, header.server)
							counter.bump
						when 'X' then
							assert_same_string (Void, nvp.value, header.x_field ("X-Powered-By"))
							counter.bump
					else
					end
				end
			end
			assert ("fully tested", counter.item = 7)
		end

	test_initialized_object_factory
		-- REFLECTION_TEST_SET.test_initialized_object_factory
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

	test_make_object_from_camel_case_table
		note
			testing: "[
				covers/{EL_SETTABLE_FROM_STRING}.make_from_table,
				covers/{EL_CAMEL_CASE_TRANSLATER}.imported
			]"
		local
			country: CAMEL_CASE_COUNTRY; table: like Ireland_table
		do
			create table.make_sized (Ireland_table.count)
			table.merge (Ireland_table)
			table.replace_key ("literacyRate", "literacy_rate")
			table.replace_key ("photoJpeg", "photo_jpeg")
			table.replace_key ("euroZoneMember", "euro_zone_member")
			create country.make_from_table (table)
			country.province_list.copy (new_country (Ireland).province_list)
			check_values_ireland (country)
		end

	test_make_object_from_table
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.make_from_table"
		do
			check_values_ireland (new_country (Ireland))
		end

	test_makeable_object_factory
		-- REFLECTION_TEST_SET.test_makeable_object_factory
		local
			type: TYPE [COLUMN_VECTOR_COMPLEX_64]
		do
			type := {COLUMN_VECTOR_COMPLEX_64}
			if attached {COLUMN_VECTOR_COMPLEX_64} Makeable_factory.new_item_from_name (type.name) as vector then
				assert_same_string (Void, type.name, vector.generator)
			else
				failed ("vector created")
			end
		end

	test_new_parameterized_item
		-- REFLECTION_TEST_SET.test_new_parameterized_item
		local
			base_type: TYPE [ANY]; parameter_types: ARRAY [TYPE [ANY]]
		do
			if attached Hash_table_factory as table_factory then
				base_type := {EL_GROUPED_LIST_TABLE [ANY, HASHABLE]}
				parameter_types := << {NATURAL_32}, {STRING} >>
				across 1 |..| 2 as n loop
				-- Testing `generic_type_factory_cache.has_hashed_key' in debugger
					if attached table_factory.new_equal_item (base_type, parameter_types, 3) as new then
						if attached {EL_GROUPED_LIST_TABLE [NATURAL_32, STRING]} new as table then
							table.extend ("one", 1)
							assert ("table count is 1", table.count = 1)
						else
							failed ("table type correct")
						end
					else
						failed ("table created")
					end
				end
			end
		end

	test_parameterized_type_id
		-- REFLECTION_TEST_SET.test_parameterized_type_id
		local
			type_id: INTEGER
		do
			type_id := Factory.parameterized_type_id ({EL_GROUPED_LIST_TABLE [ANY, HASHABLE]}, << {NATURAL}, {STRING} >>)
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
		-- REFLECTION_TEST_SET.test_reflection
		local
			table: EL_HASH_TABLE [STRING_32, IMMUTABLE_STRING_8]; object: MY_DRY_CLASS
		do
			create object.make_default
			create table.make_equal (object.field_table.count)
			across object.field_table as l_field loop
				if l_field.key.same_string ("boolean") then
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
				covers/{EL_SUBSTRING}.count,
				covers/{EL_SUBSTRING}.lines
			]"
		local
			table: HTTP_STATUS_TABLE; space_saved_percent: INTEGER
			enum_size, table_size, percent: INTEGER; choose: EL_CHOICE [INTEGER]
		do
			create table.make_default
			assert_same_http_status (table.ok, Http_status.ok)
			assert_same_http_status (table.found, Http_status.found)
			assert_same_http_status (table.continue, Http_status.continue)
			assert_same_http_status (table.not_acceptable, Http_status.not_acceptable)

			table_size := Eiffel.deep_physical_size (table) - table.text_manifest_size
			enum_size := Eiffel.deep_physical_size (Http_status)
			space_saved_percent := (enum_size - table_size) * 100 // enum_size
			lio.put_integer_field ("Memory saving", space_saved_percent)
			lio.put_character ('%%')
			lio.put_new_line

		-- Compact Object Layout: In finalized mode, objects are stored in a more compact form,
		-- which reduces their memory footprint. As a result, `{INTERNAL}.deep_physical_size' might
		-- report a smaller size compared to workbench mode				
			percent := choose [48, 26] #? Executable.is_finalized

			if space_saved_percent /= percent then
				failed (percent.out + "%% memory saving")
			end
		end

	test_set_from_other
		-- REFLECTION_TEST_SET.test_set_from_other
		note
			testing: "covers/{EL_REFLECTIVE}.set_from_other"
		local
			country: COUNTRY; country_2: COUNTRY
		do
			country := new_country (Ireland)
			create country_2.make_default
			country_2.set_from_other (country, "continent, population")
			assert ("continent is empty", country_2.continent.is_empty)
			assert ("population is zero", country_2.population = 0)
			country_2.set_continent (Ireland_table ["continent"])
			country_2.set_population (Ireland_table ["population"].to_integer)
			check_values_ireland (country_2)

			create country_2.make_default
			country_2.set_from_other (country, Void)
			check_values_ireland (country_2)
		end

	test_size_reporting
		local
			geo_info: EL_IP_ADDRESS_GEOGRAPHIC_INFO
			asn_string: EL_CODE_STRING; n_64, expected_size: INTEGER_64; l_info: SIZE_TEST
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

			expected_size := Object_header_size + {PLATFORM}.Integer_64_bytes * 4
			assert ("same size", Eiffel.deep_physical_size (l_info) = expected_size)
		end

	test_substituted_type_id
		note
			testing: "covers/{EL_INTERNAL}.substituted_type_id"
		local
			type_id: INTEGER
		do
			type_id := Factory.substituted_type_id (
				{EL_MAKEABLE_FACTORY [EL_MAKEABLE]}, {EL_MAKEABLE}, ({EL_UUID}).type_id
			)
			assert_same_string (Void,
				{ISE_RUNTIME}.generating_type_of_type (type_id), "EL_MAKEABLE_FACTORY [EL_UUID]"
			)
		end

	test_value_list
		note
			testing: "[
				covers/{EL_FIELD_TABLE}.value_list_for,
				covers/{EL_REFLECTIVE}.value_list_for,
				covers/{EL_CONTAINER_STRUCTURE}.derived_list
			]"
		local
			options: MICROSOFT_COMPILER_OPTIONS
		do
			create options.make_default
			assert_same_string (Void, options.as_switch_string, "/x64 /Release /win7")
		end

feature {NONE} -- Implementation

	to_upper (name: READABLE_STRING_8): STRING
		do
			Result := name
			Result.to_upper
		end

feature {NONE} -- Constants

	Header_response: STRING = "[
		HTTP/1.1 200 OK
		Date: Thu, 29 Aug 2024 16:09:15 GMT
		Content-Type: text/html; charset=UTF-8
		Content-Length: 5190
		Last-Modified: Mon, 08 Oct 2018 18:00:33 06
		Server: Cherokee/1.2.101 (Ubuntu)
		X-Powered-By: Eiffel-Loop Fast-CGI servlets
	]"

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

end