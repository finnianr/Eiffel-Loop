note
	description: "Test classes in `network/security' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 18:59:15 GMT (Sunday 23rd February 2025)"
	revision: "13"

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
				["is_hacker_probe",	agent test_is_hacker_probe],
				["is_whitelisted",	agent test_is_whitelisted],
				["mail_log_entries",	agent test_mail_log_entries],
				["log_entries",		agent test_log_entries],
				["ufw_user_rules",	agent test_ufw_user_rules]
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

	test_log_entries
		local
			log: EL_RECENT_LOG_ENTRIES; ip_set: EL_HASH_SET [STRING]
			ip_list: EL_STRING_8_LIST
		do
			across <<
				"77.90.185.59, 80.94.95.181, 45.66.230.184, 87.120.84.6, 87.120.84.72", -- mail.log
				"177.54.130.127, 43.155.185.104, 37.32.22.47" -- auth.log
			>> as csv loop
				ip_list := csv.item
				create ip_set.make_from (ip_list, True)

				if csv.is_first then
					create {TEST_MAIL_LOG_ENTRIES} log.make
				else
					create {TEST_AUTH_LOG_ENTRIES} log.make
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


	test_mail_log_entries
		-- SECURITY_TEST_SET.test_mail_log_entries
		local
			mail_log: PLAIN_TEXT_FILE; entries: TEST_MAIL_LOG_ENTRIES
		do
			create entries.make
			create mail_log.make_with_name (Work_area_dir #+ "mail.log")
			across new_file_list ("mail.*") as path loop
				if path.is_first then
					mail_log.open_write
				else
					mail_log.open_append
				end
				mail_log.put_string (File.plain_text (path.item))
				mail_log.close
				entries.update_spammer_ip_list
				across entries.new_spammer_ip_list as list loop
					if not list.is_first then
						lio.put_spaces (1)
					end
					lio.put_string (Ip_address.to_string (list.item))
				end
				lio.put_new_line
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