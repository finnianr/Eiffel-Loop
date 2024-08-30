note
	description: "Tests for library [./library/network.html network.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-29 18:26:54 GMT (Thursday 29th August 2024)"
	revision: "13"

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
				["log_entries",			  agent test_log_entries]
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

	test_log_entries
		-- NETWORK_TEST_SET.test_log_entries
		local
			log: EL_TODAYS_LOG_ENTRIES; ip_set: EL_HASH_SET [STRING]
			ip_list: EL_STRING_8_LIST
		do
			across <<
				"77.90.185.59, 80.94.95.181, 45.66.230.184, 87.120.84.6, 87.120.84.72", -- mail.log
				"177.54.130.127, 43.155.185.104, 37.32.22.47" -- auth.log
			>> as csv loop
				ip_list := csv.item
				create ip_set.make_from (ip_list, True)

				if csv.is_first then
					create {TEST_SENDMAIL_LOG} log.make
					log.log_path.share ("data/network/mail.log")
				else
					create {TEST_AUTHORIZATION_LOG} log.make
					log.log_path.share ("data/network/auth.log")
				end
				lio.put_labeled_string ("Scanning with " + log.generator, log.log_path)
				lio.put_new_line

				log.update_hacker_ip_list
				if attached log.new_hacker_ip_list as list then
					assert ("all new found", list.count = ip_set.count)
					from list.start until list.after loop
						assert ("expected IP", ip_set.has (Ip_address.to_string (list.item)))
						list.forth
					end
				end
				log.update_hacker_ip_list
				assert ("nothing new", log.new_hacker_ip_list.is_empty)

				assert ("adm member", log.is_log_readable)
			end
		end

feature {NONE} -- Implementation

	enum_array: ARRAY [EL_ENUMERATION [NUMERIC]]
		do
			Result := << create {EL_HTTP_STATUS_ENUM}.make, create {EL_NETWORK_DEVICE_TYPE_ENUM}.make >>
		end

end