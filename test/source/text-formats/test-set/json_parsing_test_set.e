note
	description: "Test set for [$source EL_SETTABLE_FROM_JSON_STRING] and [$source EL_JSON_NAME_VALUE_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-16 9:39:41 GMT (Saturday 16th October 2021)"
	revision: "11"

class
	JSON_PARSING_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("parse", agent test_parse)
		end

feature -- Tests

	test_parse
		local
			list: EL_JSON_NAME_VALUE_LIST
		do
			create list.make (Json_text.to_utf_8 (True))
			from list.start until list.after loop
				inspect list.index
					when 1 then
						assert ("valid name", list.name_item_8 (False) ~ "name" and list.value_item ~ My_ching.literal)
						assert ("valid escaped", Escaper.escaped (list.value_item, True) ~ My_ching.escaped)
					when 2 then
						assert ("valid price", list.name_item_8 (False) ~ "price" and list.value_item ~ Price.literal)
						assert ("valid escaped", Escaper.escaped (list.value_item, True) ~ Price.escaped)

				else end
				list.forth
			end
		end

	test_conversion
		local
			person: PERSON
		do
			create person.make_from_json (JSON_person.to_utf_8 (True))

			assert ("Correct name", person.name.same_string ("John Smith"))
			assert ("Correct city", person.city.same_string ("New York"))
			assert ("Correct age", person.age = 45)
			assert ("Correct gender", person.gender = '♂')

			assert ("same JSON", JSON_person ~ person.as_json.as_canonically_spaced)
		end

	test_json_reflection
		local
			currency, euro: JSON_CURRENCY
		do
			create euro.make ("Euro", {STRING_32}"€", "EUR")
			create currency.make_from_json (euro.as_json.to_utf_8 (True))
			assert ("same value", euro ~ currency)
		end

feature {NONE} -- Constants

	Escaper: EL_JSON_VALUE_ESCAPER
		once
			create Result.make
		end

	JSON_text: ZSTRING
		once
			Result := "[
				{
					"name" : "\"My Ching\u2122\" \uD852\uDF62",
					"price" : "\u20AC\t3.00"
				}
			]"
		end

	JSON_person: ZSTRING
		once
			Result := {STRING_32} "[
				{
					"name": "John Smith",
					"city": "New York",
					"gender": "♂",
					"age": 45
				}
			]"
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