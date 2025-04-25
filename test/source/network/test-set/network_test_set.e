note
	description: "Tests for library [./library/network.html network.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 7:11:10 GMT (Friday 25th April 2025)"
	revision: "17"

class
	NETWORK_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["network_device_type_enum", agent test_network_device_type_enum],
				["ip_address_conversion",	  agent test_ip_address_conversion]
			>>)
		end

feature -- Tests

	test_ip_address_conversion
		do
			assert ("same string", IP_address.to_string (IP_address.Loop_back) ~ "127.0.0.1")
		end

	test_network_device_type_enum
		local
			enum: EL_NETWORK_DEVICE_TYPE_ENUM
		do
			create enum.make
			assert ("name and value consistent for " + enum.generator, enum.name_and_values_consistent)
		end

end