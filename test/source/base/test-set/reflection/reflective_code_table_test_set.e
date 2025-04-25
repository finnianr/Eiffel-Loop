note
	description: "[
		Test for
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 8:47:46 GMT (Friday 25th April 2025)"
	revision: "5"

class	REFLECTIVE_CODE_TABLE_TEST_SET inherit	BASE_EQA_TEST_SET

	EL_OBJECT_PROPERTY_I

	EL_MODULE_EXECUTABLE

	EL_SHARED_HTTP_STATUS; EL_SHARED_CURRENCY_ENUM

	EL_HTTP_CODE_DESCRIPTIONS

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
		-- REFLECTIVE_CODE_TABLE_TEST_SET.test_enumeration_natural_16
		note
			testing: "[
				covers/{EL_ENUMERATION_INTEGER_16}.as_list,
				covers/{EL_ENUMERATION_INTEGER_16}.description,
				covers/{EL_ENUMERATION_INTEGER_16}.field_name,
				covers/{EL_ENUMERATION_INTEGER_16}.has_field_name,
				covers/{EL_ENUMERATION_INTEGER_16}.make,
				covers/{EL_ENUMERATION_INTEGER_16}.name
			]"
		local
			code: INTEGER_16; i: INTEGER
		do
			if attached Http_status as s and then attached code_descriptions as manifest then
				across << s.continue, s.accepted, s.found, s.bad_request, s.bad_gateway >> as list loop
					code := list.item; i := list.cursor_index
					if attached s.description (code) as description then
						assert ("has description", manifest.has_substring (super_8 (description).substring_to ('%N')))
					end
					assert_same_english_name (i, s.name (code))
				end
			end
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

	test_enumeration_natural_16
		-- REFLECTIVE_CODE_TABLE_TEST_SET.test_enumeration_integer_16
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
		local
			enum: HTTP_STATUS_ENUM; description: STRING; i: INTEGER; code: NATURAL_16
		do
			create enum.make
			assert ("valid description keys", enum.valid_description_keys)
			assert_same_string (Void, enum.description (enum.continue), "100 Client can continue.")
			if attached code_descriptions as manifest then
				across <<
					enum.continue, enum.accepted, enum.found, enum.bad_request, enum.bad_gateway
				>> as list loop
					i := list.cursor_index; code := list.item
					description := enum.description (code.item)
					assert_same_string (Void, enum.field_name (code), Name_list [i])
					assert ("starts with code", super_8 (description).substring_to (' ').to_natural_16 = code)
					assert ("has description", manifest.has_substring (super_8 (description).substring_to ('%N')))

					assert_same_english_name (i, enum.name (code))
				end
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
				covers/{EL_SUBSTRING}.lines
			]"
		local
			status: HTTP_STATUS_TABLE; description, first_line: STRING
		do
			create status.make_default
			assert_same_string (Void, status.continue.str, "100 Client can continue.")
			if attached code_descriptions as manifest then
				across <<
					status.continue, status.accepted, status.found, status.bad_request, status.bad_gateway
				>> as field loop
					description := field.item.str
					first_line := super_8 (description).substring_to ('%N')
					assert_same_string (Void, field.item.lines.first, first_line)
					assert ("has description", manifest.has_substring (first_line))
					assert ("tabs removed", not description.has ('%T'))
				end
			end
		end

feature {NONE} -- Implementation

	assert_same_english_name (i: INTEGER; code_name: STRING)
		local
			english_name: STRING
		do
			english_name := Name_list [i].twin
			if attached super_8 (english_name) as name then
				name.replace_character ('_', ' ')
				name.first_to_upper
			end
			assert_same_string (Void, english_name, code_name)
		end

feature {NONE} -- Constants

	Name_list: EL_STRING_8_LIST
		once
			Result := "continue, accepted, found, bad_request, bad_gateway"
		end
end