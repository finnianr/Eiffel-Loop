note
	description: "Reflection test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 13:08:27 GMT (Friday 25th April 2025)"
	revision: "90"

class	REFLECTION_TEST_SET inherit BASE_EQA_TEST_SET

	EL_OBJECT_PROPERTY_I

	JSON_TEST_DATA; COUNTRY_TEST_DATA

	EL_REFLECTION_CONSTANTS

	EL_MODULE_FACTORY; EL_MODULE_USER_INPUT

	EL_SHARED_FACTORIES; EL_SHARED_LOG_OPTION; EL_SHARED_SERVICE_PORT

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
				["field_name_list_for",					  agent test_field_name_list_for],
				["field_query",							  agent test_field_query],
				["field_value_reset",					  agent test_field_value_reset],
				["field_value_setter",					  agent test_field_value_setter],
				["field_value_table",					  agent test_field_value_table],
				["field_with_address",					  agent test_field_with_address],
				["http_headers",							  agent test_http_headers],
				["initialized_object_factory",		  agent test_initialized_object_factory],
				["make_object_from_camel_case_table", agent test_make_object_from_camel_case_table],
				["make_object_from_table",				  agent test_make_object_from_table],
				["makeable_object_factory",			  agent test_makeable_object_factory],
				["new_parameterized_item",				  agent test_new_parameterized_item],
				["new_factory",							  agent test_new_factory],
				["parameterized_type_id",				  agent test_parameterized_type_id],
				["reflected_collection_factory",		  agent test_reflected_collection_factory],
				["reflected_integer_list",				  agent test_reflected_integer_list],
				["reflective_string_constants",		  agent test_reflective_string_constants],
				["set_from_other",						  agent test_set_from_other],
				["settable_from_string",				  agent test_settable_from_string],
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
				covers/{EL_ATTRIBUTE_BIT_RANGE_TABLE}.make,
				covers/{EL_ATTRIBUTE_RANGE_TABLE}.initialize,
				covers/{EL_COMPACTABLE_REFLECTIVE}.make_by_compact,
				covers/{EL_COMPACTABLE_REFLECTIVE}.compact_value
			]"
		local
			date_1: COMPACTABLE_DATE; date: DATE; status, status_2: FIREWALL_STATUS
			compact_64: NATURAL_64; date_2: RANGE_COMPACTABLE_DATE; compact_date: INTEGER
			status_3: RANGE_FIREWALL_STATUS
		do
			create date.make (2005, 12, 30)

			create date_1.make (2005, 12, 30)
			assert ("fits into 32 bits", date_1.upper_bit_index = 32)
			assert ("same compact", date_1.compact_date = date.ordered_compact_date)

			create date_2.make (2005, 12, 30) -- using range intervals to define each field
			if date_2.upper_bit_index = 27 then
				do_nothing
			else
				lio.put_integer_field ("date_2.upper_bit_index", date_2.upper_bit_index)
				lio.put_new_line
				User_input.press_enter
				failed ("fits into 27 bits")
			end
			compact_date := date_2.compact_date
			assert ("same as", compact_date = 0x031CEB7D)

			create date_2.make_from_compact_date (compact_date)
			assert ("year OK", date_2.year = 2005)
			assert ("month OK", date_2.month = 12)
			assert ("day OK", date_2.day = 30)

		-- Test negative year
			date_2.set_year (-2005)
			create date_2.make_from_compact_date (date_2.compact_date)
			assert ("year OK", date_2.year = -2005)

			date.set_date (2023, 11, 2)
			date_1.set_from_compact_date (date.ordered_compact_date)
			assert ("same year", date_1.year = date.year)
			assert ("same month", date_1.month = date.month)
			assert ("same day", date_1.day = date.day)

		-- Test EL_FIREWALL_STATUS
			create status
			status.set_date (date.ordered_compact_date)
			status.block (Service_port.http)

			compact_64 := (compact_64.one |<< 32).bit_or (date.ordered_compact_date.to_natural_64)
			assert ("compact_status OK", compact_64 = status.compact_status)

			create status_2.make_from_compact (status.compact_status)
			assert ("are equal", status ~ status_2)

			create status_3
			status_3.set_date (date.ordered_compact_date)
			status_3.block (Service_port.http)
			assert ("fits into 35 bits", status_3.upper_bit_index = 35)
			assert ("same date", status_3.compact_date = date.ordered_compact_date)
			create status_3.make_from_compact (status_3.compact_status)
			assert ("same blocked ports", status.blocked_ports ~ status_3.blocked_ports)
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

	test_field_name_list_for
		-- REFLECTION_TEST_SET.test_field_name_list_for
		note
			testing: "[
				covers/{EL_FIELD_LIST}.name_list_for,
				covers/{EL_INTERNAL}.is_uniform_type,
				covers/{EL_CONTAINER_STRUCTURE}.container_first
			]"
		do
			if attached new_country (Ireland) as country
				and then attached country.string_8_field_names as name_list
			then
				assert ("count is 2", name_list.count = 2)
				assert_same_string ("fist is code", name_list.first, "code")
				assert_same_string ("fist is continent", name_list.last, "continent")
			end
		end

	test_field_query
		-- REFLECTION_TEST_SET.test_field_query
		note
			testing: "covers/{EL_FIELD_LIST}.query_by_type"
		do
			if attached new_country (Ireland) as country then
				if attached {LIST [EL_REFLECTED_INTEGER_32]} country.query_by_type ({EL_REFLECTED_INTEGER_32}) as field_list then
					assert_same_string (Void, field_list [1].name, "date_founded")
					assert_same_string (Void, field_list [2].name, "population")
				else
					failed ("query_by_type not Void")
				end
			end
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

	test_field_with_address
		-- REFLECTION_TEST_SET.test_field_with_address
		note
			testing: "covers/{EL_FIELD_LIST}.field_with_address"
		do
			assert_same_string (Void, "logging", Log_option.Name_logging)
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

	test_new_factory
		-- REFLECTION_TEST_SET.test_new_factory
		note
			testing: "[
				covers/{EL_FACTORY_TYPE_ID_TABLE}.new_item
			]"
		local
			type_id, factory_id: INTEGER
		do
			type_id := ({COLUMN_VECTOR_COMPLEX_64}).type_id
			factory_id := ({EL_MAKEABLE_FACTORY [COLUMN_VECTOR_COMPLEX_64]}).type_id
			if attached Factory.new ({EL_MAKEABLE_FACTORY [EL_MAKEABLE]}, type_id) as l_factory then
				assert ("same type", factory_id = {ISE_RUNTIME}.dynamic_type (l_factory))
			else
				failed ("create COLUMN_VECTOR_COMPLEX_64 factory")
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

	test_reflective_string_constants
		local
			name: NAME_CONSTANTS
		do
			create name
			assert ("equal strings", name.string_8 ~ String_8)
			assert ("equal strings", name.immutable_string_8 ~ Immutable_string_8)
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

	test_settable_from_string
		-- REFLECTION_TEST_SET.test_settable_from_string
		note
			testing: "[
				covers/{EL_SETTABLE_FROM_STRING}.to_table,
				covers/{EL_SETTABLE_FROM_STRING}.make_from_table
			]"
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
		-- to_table renamed as data_export
			assert ("table ~ object.data_export", table ~ object.data_export)
		end

	test_size_reporting
		local
			expected_size, actual_size: INTEGER; l_info: SIZE_TEST
		do
			create l_info
			actual_size := property (l_info).deep_physical_size
			expected_size := Object_header_size + {PLATFORM}.Integer_64_bytes * 4
			if actual_size /= expected_size then
				lio.put_integer_field ("size of instance SIZE_TEST", actual_size)
				lio.put_integer_field (" expected size", expected_size)
				lio.put_new_line

				failed ("not expected size")
			end
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

end