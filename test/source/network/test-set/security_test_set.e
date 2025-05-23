note
	description: "Test classes in `network/security' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:04:27 GMT (Sunday 4th May 2025)"
	revision: "26"

class
	SECURITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_MODULE_COMMAND; EL_MODULE_IP_ADDRESS

	SHARED_DATA_DIRECTORIES; EL_SHARED_SERVICE_PORT

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["banned_ip_table",	  agent test_banned_ip_table],
				["is_hacker_probe",	  agent test_is_hacker_probe],
				["is_whitelisted",	  agent test_is_whitelisted],
				["recent_log_entries", agent test_recent_log_entries],
				["ufw_user_rules",	  agent test_ufw_user_rules]
			>>)
		end

feature -- Test

	test_banned_ip_table
		-- SECURITY_TEST_SET.test_banned_ip_table
		local
			ip_table: EL_BANNED_IP_TABLES_SET; ip_list, digest_list: EL_STRING_8_LIST
			n: NATURAL_16; l_digest: STRING
		do
			create ip_table.make (Service_port.http, Work_area_dir, 100)
			ip_list := "152.32.180.98, 165.154.233.80, 80.94.95.71"
			digest_list := "YvcHxIoCKePgovBuYV9ZXA==, m0SUKsBFjlLwYfF5ei5Ryg=="

			across << n.zero, Service_port.https >> as port loop
				ip_table.set_related_port (port.item)
				across ip_list as list loop
					ip_table.put (IP_address.to_number (list.item))
				end
				ip_table.serialize_all
				assert_same_digest (Plain_text, ip_table.output_path, digest_list [port.cursor_index])
			end
		end

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
			log_path: FILE_PATH; auth_log_entries: EL_RECENT_AUTH_LOG_ENTRIES
		do
			create auth_log_entries.make ("workarea/tail-auth.log")
			log_entries := << create {EL_RECENT_MAIL_LOG_ENTRIES}.make ("workarea/tail-mail.log"), auth_log_entries >>
			expected_ip_addresses := <<
				"152.32.180.98, 165.154.233.80, 80.94.95.71", -- mail.log
				"218.92.0.136, 159.203.183.63, 218.92.0.246" -- auth.log
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

						lio.put_path_field ("Copying", path.item)
						lio.put_new_line
						if attached Command.new_copy_file (path.item, log_path) as cmd then
							cmd.execute
						end
						entries.update_intruder_list
						across entries.intruder_list as address loop
							ip_set.put (Ip_address.to_string (address.item))
						end
					end
					assert ("IP list OK", ip_expected_set ~ ip_set)
					lio.put_new_line
				end
			end
			if attached Ip_address.to_number ("95.45.149.152") as ssh_user_ip then
				assert ("auth.log has 1 white listed", auth_log_entries.white_listed_set.has (ssh_user_ip))
			end
		end

	test_ufw_user_rules
		-- SECURITY_TEST_SET.test_ufw_user_rules
		local
			rules: EL_UFW_USER_RULES; digest_list: EL_STRING_8_LIST
		do
			digest_list := "CAmXLsmZICk/2hOe1fErfQ==, +3J7AC/jrrEqGhPG3dnWeA=="
			if attached new_file_list ("*.rules").first_path as rules_path then
				create rules.make (rules_path)
				across << "updated.rules", "limited.rules" >> as name loop
					if name.is_last then
						rules.denied_access_table.limit_entries (2)
					end
					rules.denied_access_table.display_summary (lio, "RULE SUMMARY")
					lio.put_new_line
					rules.set_path (work_area_data_dir + name.item)
					rules.store
					assert_same_digest (Plain_text, rules.path, digest_list [name.cursor_index])
				end
			end
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := Data_dir.network #+ "security"
		end
end