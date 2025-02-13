note
	description: "Test classes in `network/security' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-13 18:29:03 GMT (Thursday 13th February 2025)"
	revision: "6"

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
				["ufw_user_rules",  agent test_ufw_user_rules],
				["is_hacker_probe", agent test_is_hacker_probe]
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

				first_step := predicate_list [1]; has_extension := predicate_list [2]
				starts_with := predicate_list [3]; ends_with := predicate_list [4]

				assert_same_string (Void, first_step, "first_step")
				assert_same_string (Void, has_extension, "has_extension")
				assert_same_string (Void, starts_with, "starts_with")
				assert_same_string (Void, ends_with, "ends_with")

				filter.extend ("asp", has_extension)
				filter.extend ("bot", first_step)
				filter.extend ("store", ends_with)
				filter.put_whitelist ("bot/permitted")

				assert ("max digits exceeded", filter.is_hacker_probe ("87543bde9176626b120898f9141058"))
				assert ("max digits OK for image", not filter.is_hacker_probe ("images/picture-256x256.jpeg"))

				assert ("extension asp", filter.is_hacker_probe ("home/index.asp"))
				assert ("starts with bot", filter.is_hacker_probe ("bot/api"))
				assert ("permitted bot", not filter.is_hacker_probe ("bot/permitted"))
				assert ("match", filter.is_hacker_probe (".ds_store"))
				assert ("not match", not filter.is_hacker_probe ("en/home.html"))
			end
		end

	test_ufw_user_rules
		-- SECURITY_TEST_SET.test_ufw_user_rules
		local
			rules: EL_UFW_USER_RULES
		do
			if attached new_file_list ("*.rules").first_path as rules_path then
				create rules.make (rules_path)
				rules.write (work_area_data_dir + "updated.rules")
				rules.limit_entries (2)
				rules.write (work_area_data_dir + "limited.rules")
			end
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "security"
		end
end