note
	description: "Tests for library [./library/network.html network.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-16 8:50:38 GMT (Wednesday 16th June 2021)"
	revision: "1"

class
	NETWORK_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("ip_address_conversion", agent test_ip_address_conversion)
		end

feature -- Tests

	test_ip_address_conversion
		do
			assert ("same string", IP_address.to_string (IP_address.Loop_back_address) ~ "127.0.0.1")
		end

end