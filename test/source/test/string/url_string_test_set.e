note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"

	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-11-13 18:04:29 GMT (Friday 13th November 2015)"
	revision: "1"

class
	URL_STRING_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_to_string

		note
			testing: "covers/{EL_URL_STRING}.to_string"
		local
			uri: EL_URL_STRING
		do
			create uri.make_encoded ("address_city=D%%FAn+B%%FAinne")
			assert ("is_equal", uri.to_string.to_latin_1 ~ "address_city=Dn Binne")
		end

end

