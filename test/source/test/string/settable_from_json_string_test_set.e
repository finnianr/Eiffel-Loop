note
	description: "Test reflective JSON"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-19 13:14:53 GMT (Wednesday 19th September 2018)"
	revision: "1"

class
	SETTABLE_FROM_JSON_STRING_TEST_SET

inherit
	EQA_TEST_SET

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

feature {NONE} -- Constants

	JSON_person: ZSTRING
		once
			Result := {STRING_32} "[
				{ "name": "John Smith", "city": "New York", "gender": "♂", "age": "45" }
			]"
		end

end
