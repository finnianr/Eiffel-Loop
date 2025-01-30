note
	description: "Test ${EL_URL_FILTER_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-29 9:28:48 GMT (Wednesday 29th January 2025)"
	revision: "1"

class
	URL_FILTER_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["first_step_match",	agent test_first_step_match]
			>>)
		end

feature -- Test

	test_first_step_match
		-- URL_FILTER_TABLE_TEST_SET.test_first_step_match
		local
			filter: EL_URL_FILTER_TABLE; uri_array: EL_ZSTRING_LIST
		do
			create filter.make (7)
			uri_array := "bot/api, bottle"
			if attached filter.new_predicate_list as predicate_list then
				assert ("first_step", predicate_list.first ~ "first_step")
				filter.extend (predicate_list.first, "bot")
				assert ("is hacker", filter.is_hacker_probe (uri_array [1]))
				assert ("is not hacker", not filter.is_hacker_probe (uri_array [2]))
			end
		end

end