note
	description: "Tests for library [./library/network.html network.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-28 9:19:24 GMT (Saturday 28th October 2023)"
	revision: "10"

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
				["ip_address_conversion", agent test_ip_address_conversion],
				["sendmail_log",			  agent test_sendmail_log]
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

	test_sendmail_log
		-- NETWORK_TEST_SET.test_sendmail_log
		local
			log: TODAYS_SENDMAIL_LOG; spammer_ip_set: EL_HASH_SET [STRING]
		do
			create spammer_ip_set.make_from_array (<<
				"77.90.185.59", "80.94.95.181", "45.66.230.184", "87.120.84.6", "87.120.84.72"
			>>)
			create log.make
			log.log_path.share ("data/network/mail.log")

			log.update_relay_spammer_list
			if attached log.new_relay_spammer_list as list then
				assert ("found 6 new", list.count = spammer_ip_set.count)
				from list.start until list.after loop
					assert ("expected IP", spammer_ip_set.has (Ip_address.to_string (list.item)))
					list.forth
				end
			end
			log.update_relay_spammer_list
			assert ("nothing new", log.new_relay_spammer_list.is_empty)

			assert ("adm member", log.is_log_readable)
		end

feature {NONE} -- Implementation

	enum_array: ARRAY [EL_ENUMERATION [NUMERIC]]
		do
			Result := << create {EL_HTTP_STATUS_ENUM}.make, create {EL_NETWORK_DEVICE_TYPE_ENUM}.make >>
		end

end