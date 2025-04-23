note
	description: "[
		Test for
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-23 19:21:16 GMT (Wednesday 23rd April 2025)"
	revision: "3"

class	REFLECTIVE_CODE_TABLE_TEST_SET inherit	BASE_EQA_TEST_SET

	EL_OBJECT_PROPERTY_I

	EL_MODULE_EXECUTABLE

	EL_SHARED_HTTP_STATUS; EL_SHARED_CURRENCY_ENUM

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["enumeration_integer_16",	 agent test_enumeration_integer_16],
				["enumeration_natural_16",	 agent test_enumeration_natural_16],
				["enumeration_natural_8",	 agent test_enumeration_natural_8],
				["field_representation",	 agent test_field_representation],
				["reflective_string_table", agent test_reflective_string_table]
			>>)
		end

feature -- Tests

	test_enumeration_integer_16
		-- REFLECTIVE_CODE_TABLE_TEST_SET.test_enumeration_integer_16
		note
			testing: "[
				covers/{EL_ENUMERATION}.as_list
			]"
		local
			enum: HTTP_STATUS_INTEGER_16_ENUM; enum_2: ARRAY [NATURAL_16]
			size_proportion, size_enum, size_enum_2: INTEGER
		do
			create enum.make_default
			if attached Http_status as status then
				enum_2 := << status.continue, status.accepted, status.found, status.bad_request, status.bad_gateway >>
			end
			across <<
				enum.continue, enum.accepted, enum.found, enum.bad_request, enum.bad_gateway
			>> as code loop
				assert_same_string (Void, enum.description (code.item), Http_status.description (enum_2 [code.cursor_index]))
			end
			size_enum := property (enum).deep_physical_size
			size_enum_2 := property (Http_status).deep_physical_size
			size_proportion := (size_enum * 100 / size_enum_2).rounded
			if size_proportion /= 59 then
				lio.put_integer_field ("Size " + enum.generator, size_enum)
				lio.put_new_line
				lio.put_integer_field ("Size " + Http_status.generator, size_enum_2)
				lio.put_new_line
				failed (enum.generator + " is x%% smaller")
			end
		end

	test_enumeration_natural_16
		-- REFLECTIVE_CODE_TABLE_TEST_SET.test_enumeration_natural_16
		note
			testing: "[
				covers/{EL_ENUMERATION}.initialize_fields,
				covers/{EL_ENUMERATION}.codes_in_description,
				covers/{EL_ENUMERATION}.as_list,
				covers/{EL_ENUMERATION}.description,
				covers/{EL_ENUMERATION}.name,
				covers/{EL_ENUMERATION}.field_name,
				covers/{EL_ENUMERATION}.has_field_name,
				covers/{EL_ENUMERATION}.value,
				covers/{EL_HTTP_CODE_DESCRIPTIONS}.code_descriptions
			]"
		do
			if Http_status.valid_description_keys then
				assert_same_string (Void, Http_status.description (Http_status.continue), "100 Client can continue.")
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
		end

	test_enumeration_natural_8
		note
			testing: "[
				covers/{EL_ENUMERATION_NATURAL_8}.make,
				covers/{EL_ENGLISH_NAME_TRANSLATER}.set_uppercase_exception_set
			]"
		local
			string_encoding: TL_STRING_ENCODING_ENUM
		do
		-- Class `TL_STRING_ENCODING_ENUM' using `field_by_value_array' (non-continuous array)
			create string_encoding.make
			if attached string_encoding.as_list as list then
				assert ("first is latin_1", list.first = string_encoding.latin_1)
				assert ("last is utf_16_little_endian", list.last = string_encoding.utf_16_little_endian)
				assert_same_string (Void,
					string_encoding.name (string_encoding.utf_16_little_endian), "UTF 16 little endian"
				)
			end

		-- `Currency_enum' using `field_by_value_array'
			assert_same_string (Void, Currency_enum.name (Currency_enum.EUR), "EUR")
			assert_same_string (Void, Currency_enum.field_name (Currency_enum.EUR), "eur")
			if attached Currency_enum.as_list as list then
				assert ("first is AUD", list.first = Currency_enum.AUD)
				assert ("last is ZAR", list.last = Currency_enum.ZAR)
			end
		end

	test_field_representation
		local
			representation: EL_ENUMERATION_REPRESENTATION [NATURAL_8]
		do
			representation := Currency_enum.to_representation
			assert ("EURO is 9", representation.to_value ("EUR") = (9).to_natural_8)
		end

	test_reflective_string_table
		-- REFLECTIVE_CODE_TABLE_TEST_SET.test_reflective_string_table
		note
			testing: "[
				covers/{EL_STRING_ITERATION_CURSOR}.occurrences_in_bounds,
				covers/{EL_TABLE_INTERVAL_MAP_LIST}.make,
				covers/{EL_REFLECTIVE_STRING_TABLE}.make,
				covers/{EL_SUBSTRING}.count,
				covers/{EL_SUBSTRING}.lines,
				covers/{EL_HTTP_CODE_DESCRIPTIONS}.code_descriptions
			]"
		local
			table: HTTP_STATUS_TABLE; space_saved_percent: INTEGER
			enum_size, table_size, percent: INTEGER; choose: EL_CHOICE [INTEGER]
		do
			create table.make_default
			assert_same_description (table.ok, Http_status.ok)
			assert_same_description (table.found, Http_status.found)
			assert_same_description (table.continue, Http_status.continue)
			assert_same_description (table.not_acceptable, Http_status.not_acceptable)

			table_size := property (table).deep_physical_size - table.text_manifest_size
			enum_size := property (Http_status).deep_physical_size
			space_saved_percent := (enum_size - table_size) * 100 // enum_size
			lio.put_integer_field ("Memory saving", space_saved_percent)
			lio.put_character ('%%')
			lio.put_new_line

		-- Compact Object Layout: In finalized mode, objects are stored in a more compact form,
		-- which reduces their memory footprint. As a result, `{INTERNAL}.deep_physical_size' might
		-- report a smaller size compared to workbench mode				
			percent := choose [53, 36] #? Executable.is_finalized

			if space_saved_percent /= percent then
				failed (percent.out + "%% memory saving")
			end
		end

feature {NONE} -- Implementation

	assert_same_description (status: EL_MANIFEST_SUBSTRING_8; status_code: NATURAL_16)
		do
			assert_same_string ("same description", status.string, Http_status.description (status_code))
		end

end