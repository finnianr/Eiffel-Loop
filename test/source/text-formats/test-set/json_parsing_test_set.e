note
	description: "Test set for [$source EL_JSON_SETTABLE_FROM_STRING] and [$source EL_JSON_NAME_VALUE_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-21 13:54:36 GMT (Tuesday 21st June 2022)"
	revision: "18"

class
	JSON_PARSING_TEST_SET

inherit
	EL_EQA_TEST_SET

	JSON_TEST_DATA

	EL_CRC_32_TEST_ROUTINES

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("json_across_iteration", agent test_json_across_iteration)
			eval.call ("json_intervals_object", agent test_json_intervals_object)
			eval.call ("json_reflection_1", agent test_json_reflection_1)
			eval.call ("json_reflection_3", agent test_json_reflection_3)
			eval.call ("parse", agent test_parse)
		end

feature -- Tests

	test_json_across_iteration
		note
			testing: "covers/{EL_JSON_FIELD_NAME_INTERVALS}.make, covers/{EL_JSON_ZNAME_VALUE_LIST}.new_cursor"
		local
			list: EL_JSON_ZNAME_VALUE_LIST; checksum_1: NATURAL
			crc: like crc_generator
		do
			crc := crc_generator
			create list.make (JSON_price.to_utf_8 (True))
			from list.start until list.after loop
				crc.add_string (list.name_item (False))
				crc.add_string (list.value_item (False))
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

	test_json_intervals_object
		note
			testing: "covers/{EL_JSON_INTERVALS_OBJECT}.make"
		local
			meta_data: EL_IP_ADDRESS_META_DATA
		do
			create meta_data.make (JSON_eiffel_loop_ip)
			assert ("not in EU", not meta_data.in_eu)

			assert ("same asn", meta_data.asn ~ "AS8560")
			assert ("same country", meta_data.country ~ "GB")

			assert ("same city", meta_data.city.same_string ("Kensington"))
			assert ("same country_name", meta_data.country_name.same_string ("United Kingdom"))
			assert ("same region", meta_data.region.same_string ("England"))

			assert ("same country_area", meta_data.country_area = 244820.6)
			assert ("same country_population", meta_data.country_population = 66488991)
			assert ("same latitude", meta_data.latitude = 51.4957)
			assert ("same longitude", meta_data.longitude = -0.1772)

			lio.put_integer_field ("meta_data size in RAM", meta_data.physical_size)
			lio.put_new_line

			meta_data.print_memory (lio)
		end

	test_json_reflection_1
		note
			testing: "covers/{EL_JSON_SETTABLE_FROM_STRING}.set_from_json"
		local
			person: PERSON
		do
			create person.make_from_json (JSON_person.to_utf_8 (True))

			assert ("Correct name", person.name.same_string ("John Smith"))
			assert ("Correct city", person.city.same_string ("New York"))
			assert ("Correct age", person.age = 45)
			assert ("Correct gender", person.gender = '♂')

			assert ("same JSON", JSON_person ~ person.as_json)
		end

	test_json_reflection_3
		note
			testing: "covers/{EL_JSON_SETTABLE_FROM_STRING}.set_from_json",
				"covers/{EL_REFLECTED_INTEGER_FIELD}.set_from_double"
		local
			currency, euro: JSON_CURRENCY
		do
			create euro.make ("Euro", {STRING_32}"€", "EUR")
			create currency.make_from_json (euro.as_json.to_utf_8 (True))
			assert ("same value", euro ~ currency)
		end

	test_parse
		note
			testing: "covers/{EL_JSON_FIELD_NAME_INTERVALS}.make"
		local
			list: EL_JSON_NAME_VALUE_LIST
		do
			create list.make (JSON_price.to_utf_8 (True))
			from list.start until list.after loop
				inspect list.index
					when 1 then
						assert ("valid name", list.name_item (False) ~ "name" and list.value_item (False) ~ My_ching.literal)
						assert ("valid escaped", Escaper.escaped (list.value_item (False), True) ~ My_ching.escaped)
					when 2 then
						assert ("valid price", list.name_item (False) ~ "price" and list.value_item (False) ~ Price.literal)
						assert ("valid escaped", Escaper.escaped (list.value_item (False), True) ~ Price.escaped)

				else end
				list.forth
			end
		end

feature {NONE} -- Constants

	Escaper: EL_JSON_VALUE_ESCAPER
		once
			create Result.make
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