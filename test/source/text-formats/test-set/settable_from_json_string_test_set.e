note
	description: "Test reflective JSON"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-05 10:47:00 GMT (Tuesday 5th May 2020)"
	revision: "5"

class
	SETTABLE_FROM_JSON_STRING_TEST_SET

inherit
	EL_EQA_REGRESSION_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("conversion", agent test_conversion)
			eval.call ("json_reflection", agent test_json_reflection)
		end

feature -- Tests

	test_conversion
		local
			person: PERSON
		do
			create person.make_from_json (JSON_person.to_utf_8)

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
			create currency.make_from_json (euro.as_json.to_utf_8)
			assert ("same value", euro ~ currency)
		end

feature {NONE} -- Constants

	JSON_person: ZSTRING
		once
			Result := {STRING_32} "[
				{ "name": "John Smith", "city": "New York", "gender": "♂", "age": "45" }
			]"
		end

end
