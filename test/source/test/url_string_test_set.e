note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

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
			assert ("is_equal", uri.to_string.to_latin1 ~ "address_city=Dún Búinne")
		end

end


