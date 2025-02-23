note
	description: "Tests for library [./library/network.html network.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 18:32:19 GMT (Sunday 23rd February 2025)"
	revision: "14"

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
				["enumerations",			  agent test_enumerations],
				["ip_address_conversion", agent test_ip_address_conversion]
			>>)
		end

feature -- Tests

	test_enumerations
		do
			across enum_array as enum loop
				assert ("name and value consistent for " + enum.item.generator, enum.item.name_and_values_consistent)
			end
		end

	test_ip_address_conversion
		do
			assert ("same string", IP_address.to_string (IP_address.Loop_back_address) ~ "127.0.0.1")
		end

feature {NONE} -- Implementation

	enum_array: ARRAY [EL_ENUMERATION [NUMERIC]]
		do
			Result := << create {EL_HTTP_STATUS_ENUM}.make, create {EL_NETWORK_DEVICE_TYPE_ENUM}.make >>
		end

end