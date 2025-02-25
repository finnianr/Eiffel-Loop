note
	description: "Test classes in `network/security' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-25 10:45:28 GMT (Tuesday 25th February 2025)"
	revision: "15"

class
	SECURITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_MODULE_IP_ADDRESS

	SHARED_DEV_ENVIRON

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["is_hacker_probe",	  agent test_is_hacker_probe],
				["is_whitelisted",	  agent test_is_whitelisted],
				["recent_log_entries", agent test_recent_log_entries],
				["ufw_user_rules",	  agent test_ufw_user_rules]
			>>)
		end

feature -- Test

	test_is_hacker_probe
		-- SECURITY_TEST_SET.test_is_hacker_probe
		note
			testing: "[
				covers/{EL_URL_FILTER_TABLE}.matches,
				covers/{EL_URL_FILTER_TABLE}.matches_predicate,
				covers/{EL_URL_FILTER_TABLE}.is_digit_count_exception,
				covers/{EL_URL_FILTER_TABLE}.is_hacker_probe
			]"
		local
			first_step, has_extension, starts_with, ends_with: STRING
			filter: EL_URI_FILTER_TABLE; max_digits_exceeded: BOOLEAN
		do
			create filter.make
			if attached filter.predicate_list as predicate_list then
				assert ("4 predicate names", predicate_list.count = 4)

				has_extension := predicate_list [1]; first_step := predicate_list [2];
				starts_with := predicate_list [3]; ends_with := predicate_list [4]

				assert_same_string (Void, first_step, "first_step")
				assert_same_string (Void, has_extension, "has_extension")
				assert_same_string (Void, starts_with, "starts_with")
				assert_same_string (Void, ends_with, "ends_with")

				across << 3, 50 >> as n loop
					filter.set_maximum_uri_digits (n.item)
					max_digits_exceeded := filter.is_hacker_probe ("87543bde9176626b120898f9141058")
					if n.is_first then
						assert ("max digits exceeded", max_digits_exceeded)
					else
						assert ("not max digits exceeded", not max_digits_exceeded)
					end
					assert ("max digits OK for image", not filter.is_hacker_probe ("images/picture-256x256.jpeg"))
				end

				filter.extend (".", starts_with)
				assert ("has_excluded_first_characters", filter.has_excluded_first_characters)
				assert (".env", filter.is_hacker_probe (".env"))

				filter.extend ("asp", has_extension)
				assert ("extension asp", filter.is_hacker_probe ("home/index.asp"))

				filter.extend ("bot", first_step)
				assert ("starts with bot", filter.is_hacker_probe ("bot/api"))

				filter.extend ("store", ends_with)
				assert ("match", filter.is_hacker_probe (".ds_store"))

				assert ("not match", not filter.is_hacker_probe ("en/home.html"))
			end
		end

	test_is_whitelisted
		-- SECURITY_TEST_SET.test_is_whitelisted
		local
			filter: EL_URI_FILTER_TABLE
		do
			create filter.make
			if attached (".well-known/pki-validation/") as pki_validation then
				filter.put_whitelist (pki_validation + "*")
				assert ("whitelisted URI", filter.is_whitelisted (pki_validation + "87543bde9176626.txt"))
			end

			if attached ("bot/permitted") as uri then
				filter.put_whitelist (uri)
				assert ("whitelisted", filter.is_whitelisted (uri))
			end
		end

	test_recent_log_entries
		-- SECURITY_TEST_SET.test_recent_log_entries
		local
			log_file: PLAIN_TEXT_FILE; expected_ip_addresses: ARRAY [EL_STRING_8_LIST]
			ip_set, ip_expected_set: EL_HASH_SET [STRING]; log_entries: ARRAY [EL_RECENT_LOG_ENTRIES]
			log_path: FILE_PATH
		do
			log_entries := << create {TEST_MAIL_LOG_ENTRIES}.make, create {TEST_AUTH_LOG_ENTRIES}.make >>
			expected_ip_addresses := <<
				"152.32.180.98, 165.154.233.80, 80.94.95.71", "218.92.0.136, 159.203.183.63"
			>>
			create ip_set.make_equal (3)
			across log_entries as list loop
				if attached list.item as entries then
					create ip_expected_set.make_from (expected_ip_addresses [list.cursor_index], True)
					log_path := entries.log_path
					lio.put_path_field ("Testing", log_path)
					lio.put_new_line
					ip_set.wipe_out
					create log_file.make_with_name (Work_area_dir #+ log_path.base)
					across new_file_list (log_path.base_name + ".*") as path loop
						lio.put_path_field ("Appending", path.item)
						lio.put_new_line
						if path.is_first then
							log_file.open_write
						else
							log_file.open_append
						end
						log_file.put_string (File.plain_text (path.item))
						log_file.close
						entries.update_intruder_set
						across entries.intruder_set as address loop
							ip_set.put (Ip_address.to_string (address.item))
						end
					end
					assert ("IP list OK", ip_expected_set ~ ip_set)
					lio.put_new_line
				end
			end
		end

	test_ufw_user_rules
		-- SECURITY_TEST_SET.test_ufw_user_rules
		local
			rules: EL_UFW_USER_RULES; l_digest: STRING
		do
			if attached new_file_list ("*.rules").first_path as rules_path then
				create rules.make (rules_path)
				across << "updated.rules", "limited.rules" >> as name loop
					if name.is_last then
						rules.limit_entries (2)
					end
					rules.display_summary (lio, "RULE SUMMARY")
					lio.put_new_line
					rules.set_path (work_area_data_dir + name.item)
					rules.store
					l_digest := if name.is_first then "SGUyrMx2AUMkAtNCwc4Jag==" else "Pw0TGyxl0CC4iP27WpCpkw==" end
					assert_same_digest (Plain_text, rules.path, l_digest)

				end
			end
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "network/security"
		end
end