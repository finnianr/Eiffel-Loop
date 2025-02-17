note
	description: "Test classes in `network/security' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-17 8:43:35 GMT (Monday 17th February 2025)"
	revision: "9"

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
				["is_hacker_probe", agent test_is_hacker_probe],
				["ufw_user_rules",  agent test_ufw_user_rules]
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
			filter: EL_URI_FILTER_TABLE
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

				filter.extend ("asp", has_extension)
				filter.extend ("bot", first_step)
				filter.extend ("store", ends_with)
				filter.put_whitelist ("bot/permitted")

				assert ("max digits exceeded", filter.is_hacker_probe ("87543bde9176626b120898f9141058", Mozzilla_firefox))
				assert ("max digits OK for image", not filter.is_hacker_probe ("images/picture-256x256.jpeg", Mozzilla_firefox))

				assert ("extension asp", filter.is_hacker_probe ("home/index.asp", Mozzilla_firefox))
				assert ("starts with bot", filter.is_hacker_probe ("bot/api", Mozzilla_firefox))
				assert ("permitted bot", not filter.is_hacker_probe ("bot/permitted", Mozzilla_firefox))
				assert ("match", filter.is_hacker_probe (".ds_store", Mozzilla_firefox))
				assert ("not match", not filter.is_hacker_probe ("en/home.html", Mozzilla_firefox))
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
			Result := Dev_environ.EL_test_data_dir #+ "security"
		end

feature -- Constants

	Mozzilla_firefox: STRING = "Mozzilla firefox"
end