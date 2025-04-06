note
	description: "Test set for ${JSON_SETTABLE_FROM_STRING} and ${JSON_NAME_VALUE_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 11:39:39 GMT (Sunday 6th April 2025)"
	revision: "35"

class
	JSON_PARSING_TEST_SET

inherit
	EL_EQA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_STRING_8_CONSTANTS

	JSON_TEST_DATA

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32; EL_SHARED_ESCAPE_TABLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["across_iteration", agent test_across_iteration],
				["array_parsing", agent test_array_parsing],
				["canonically_spaced_json", agent test_canonically_spaced_json],
				["field_search", agent test_field_search],
				["intervals_object", agent test_intervals_object],
				["parse", agent test_parse],
				["reflection_1", agent test_reflection_1],
				["reflection_3", agent test_reflection_3]
			>>)
		end

feature -- Tests

	test_across_iteration
		note
			testing: "[
				covers/{JSON_PARSED_INTERVALS}.make,
				covers/{JSON_ZNAME_VALUE_LIST}.new_cursor
			]"
		local
			list: JSON_ZNAME_VALUE_LIST; checksum_1: NATURAL
			crc: like crc_generator
		do
			crc := crc_generator
			create list.make (JSON_price.to_utf_8)
			from list.start until list.after loop
				crc.add_string (list.item_name (False))
				crc.add_string (list.item_value (False))
				list.forth
			end
			checksum_1 := crc.checksum

			crc.reset
			across list as l loop
				if attached l.item as pair then
					crc.add_string (pair.name)
					crc.add_string (pair.value)
				end
			end
			assert ("same checksums", checksum_1 = crc.checksum)
		end

	test_array_parsing
		note
			testing: "covers/{JSON_PARSED_INTERVALS}.make"
		local
			list: JSON_NAME_VALUE_LIST; data_list: EL_STRING_8_LIST
		do
			create list.make (JSON_vector_plane_data)
			create data_list.make (JSON_vector_plane_data.occurrences ('%N') + 1)
			from list.start until list.after loop
				if list.item_same_as ("q") then
					append_json (list.item_name (False), data_list, list.item_2d_integer_array)
					data_list.last.append_character (',')
				elseif list.item_same_as ("p") then
					append_json (list.item_name (False), data_list, list.item_2d_double_array)
				end
				list.forth
			end
			data_list.indent (1)
			data_list.put_front ("{") data_list.extend ("}")
			if attached data_list.joined_lines as json_data then
--				force data to match with adjustment to DOUBLE rounding
				json_data.replace_substring_all ("110399", "110396")
				if JSON_vector_plane_data /~ json_data then
					lio.put_curtailed_string_field ("JSON", json_data, json_data.count)
					lio.put_new_line
					failed ("same data except for rounding difference")
				end
			end
		end

	test_canonically_spaced_json
		-- JSON_PARSING_TEST_SET.test_canonically_spaced_json
		local
			snapshots_list: JSON_ZNAME_VALUE_LIST; count: INTEGER
			url: TUPLE [beginning, ending: STRING]
		do
			url := ["http://", "/lofting/bx101010.html"]
			across << JSON_archived_snapshots.as_canonically_spaced, JSON_archived_snapshots >> as json loop
				create snapshots_list.make (json.item.to_latin_1)
				count := 0
				if attached snapshots_list as list then
					from list.start until list.after loop
						if list.item_same_as ("url") then
							assert ("url ending OK", list.item_immutable_value.ends_with (url.ending))
							assert ("url beginning OK", list.item_immutable_value.starts_with (url.beginning))
							count := count + 1
						elseif list.item_same_as ("status") then
							assert ("status OK", list.item_integer = 200)
							count := count + 1
						elseif list.item_same_as ("available") then
							assert ("available OK", list.item_boolean)
							count := count + 1
						elseif list.item_same_as ("timestamp") then
							assert ("timestamp OK", list.item_natural_64 = 20130124193934)
							count := count + 1
						end
						list.forth
					end
					assert ("found 5 fields", count = 5)
				end
			end
		end

	test_field_search
		-- JSON_PARSING_TEST_SET.test_field_search
		local
			list: JSON_NAME_VALUE_LIST; uri: EL_URI
		do
			create list.make (JSON_archived_snapshots.to_latin_1)
			list.find_field ("url")
			assert ("found field", list.found)
			uri := list.item_immutable_value
			assert ("authority OK", uri.authority ~ "www.emotionaliching.com")

			list.find_next -- url
			assert ("found field", list.found)
			uri := list.item_immutable_value
			assert ("authority OK", uri.authority ~ "web.archive.org")
		end

	test_intervals_object
		-- JSON_PARSING_TEST_SET.test_intervals_object
		note
			testing: "covers/{JSON_INTERVALS_OBJECT}.make"
		local
			meta_data: EL_IP_ADDRESS_META_DATA
		do
			create meta_data.make (JSON_eiffel_loop_ip)
			assert ("not in EU", not meta_data.in_eu)

			assert ("same asn", meta_data.asn ~ "AS8560")
			assert ("same country", meta_data.country ~ "GB")

			assert_same_string ("same city", meta_data.city, "Kensington")
			assert_same_string ("same country_name", meta_data.country_name, "United Kingdom")
			assert_same_string ("same region", meta_data.region, "England")

			assert ("same country_area", meta_data.country_area = 244820.6)
			assert ("same country_population", meta_data.country_population = 66488991)
			assert ("same latitude", meta_data.latitude = 51.4957)
			assert ("same longitude", meta_data.longitude = -0.1772)

			lio.put_integer_field ("meta_data size in RAM", meta_data.physical_size)
			lio.put_new_line

			meta_data.print_memory (lio)
		end

	test_parse
		-- JSON_PARSING_TEST_SET.test_parse
		note
			testing: "covers/{JSON_PARSED_INTERVALS}.make"
		local
			list: JSON_NAME_VALUE_LIST
		do
			create list.make (JSON_price.to_utf_8)
			from list.start until list.after loop
				inspect list.index
					when 1 then
						assert ("valid name", list.item_same_as ("name") and list.item_value (False) ~ My_ching.literal)
						assert ("valid escaped", Escaper.escaped (list.item_value (False), True) ~ My_ching.escaped)
					when 2 then
						assert ("valid price", list.item_same_as ("price") and list.item_value (False) ~ Price.literal)
						assert ("valid escaped", Escaper.escaped (list.item_value (False), True) ~ Price.escaped)

				else end
				list.forth
			end
		end

	test_reflection_1
		note
			testing: "covers/{JSON_SETTABLE_FROM_STRING}.set_from_json"
		local
			person: PERSON
		do
			create person.make_from_json (JSON_person.to_utf_8)

			assert_same_string ("same name", person.name, "John Smith")
			assert_same_string ("Correct city", person.city, "New York")
			assert ("Correct age", person.age = 45)
			assert ("Correct gender", person.gender = '♂')

			assert ("same JSON", JSON_person ~ person.as_json)
		end

	test_reflection_3
		note
			testing: "covers/{JSON_SETTABLE_FROM_STRING}.set_from_json",
				"covers/{EL_REFLECTED_INTEGER_FIELD}.set_from_double"
		local
			currency, euro: JSON_CURRENCY
		do
			create euro.make ("Euro", {STRING_32}"€", "EUR")
			create currency.make_from_json (euro.as_json.to_utf_8)
			assert ("same value", euro ~ currency)
		end

feature {NONE} -- Implementation

	append_json (name: STRING; list: EL_STRING_8_LIST; array: ARRAY2 [ANY])
		local
			i, j: INTEGER
		do
			list.extend ("%"" + name + "%": [")
			from i := 1 until i > array.height loop
				if i > 1 then
					list.last.append (",")
				end
				list.extend ("%T[")
				from j := 1 until j > array.width loop
					if j > 1 then
						list.last.append (", ")
					end
					list.last.append (array [i, j].out)
					j := j + 1
				end
				list.last.append_character (']')
				i := i + 1
			end
			list.extend ("]")
		end

feature {NONE} -- Constants

	Escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.JSON)
		end

	My_ching: TUPLE [literal, escaped: ZSTRING]
		once
			create Result
			Result.literal := {STRING_32} "%"My Ching™%" "
			Result.literal.append_unicode (0x24B62)-- Han character
			Result.escaped := {STRING_32} "\%"My Ching™\%" "
			Result.escaped.append_unicode (0x24B62)-- Han character
		end

	Price: TUPLE [literal, escaped: ZSTRING]
		once
			create Result
			Result.literal := {STRING_32} "€%T3.00"
			Result.escaped := {STRING_32} "€\t3.00"
		end

end