note
	description: "Tests for library [./library/network.html network.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:50:57 GMT (Tuesday 4th October 2022)"
	revision: "3"

class
	NETWORK_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("enumerations", agent test_enumerations)
			eval.call ("ip_address_conversion", agent test_ip_address_conversion)
		end

feature -- Tests

	test_enumerations
		local
			enum_array: ARRAY [EL_ENUMERATION [NUMERIC]]
		do
			enum_array := << create {EL_HTTP_STATUS_ENUM}.make, create {EL_NETWORK_DEVICE_TYPE_ENUM}.make >>
			across enum_array as enum loop
				assert ("name and value consistent for " + enum.item.generator, enum.item.name_and_values_consistent)
			end
		end

	test_ip_address_conversion
		do
			assert ("same string", IP_address.to_string (IP_address.Loop_back_address) ~ "127.0.0.1")
		end

end