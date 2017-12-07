note
	description: "Summary description for {REFLECTIVELY_JSON_SETTABLE_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 14:00:08 GMT (Saturday 2nd December 2017)"
	revision: "1"

class
	REFLECTIVELY_JSON_SETTABLE_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LOG
		undefine
			default_create
		end

feature -- Account Linking

	test_serialization
		local
			currency, euro: JSON_CURRENCY
		do
			log.enter ("test_serialization")
			create euro.make ("Euro", {STRING_32}"€", "EUR")
			create currency.make_from_json (euro.as_json)
			assert ("same value", euro ~ currency)
			log.exit
		end

end
