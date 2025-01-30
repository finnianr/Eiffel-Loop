note
	description: "Test class ${EL_WEB_LOG_ENTRY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-29 9:14:59 GMT (Wednesday 29th January 2025)"
	revision: "5"

class
	WEB_LOG_ENTRY_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["log_entry", agent test_log_entry]
			>>)
		end

feature -- Test

	test_log_entry
		-- WEB_LOG_ENTRY_TEST_SET.test_log_entry
		local
			entry: EL_WEB_LOG_ENTRY; line, referer, user_agent, request_uri: ZSTRING
		do
			referer := "http://matryoshka.software/en/purchase.html"
			user_agent := "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
			request_uri := "/en/home.html"
			line := "[
				86.41.71.251 - - [06/May/2022:14:25:51 +0000] "GET # HTTP/1.1" 200 20346 "#" "#"
			]"
			line.replace_character ('%N', ' ')
			create entry.make (line #$ [request_uri, referer, user_agent])
			if attached entry.date as d then
				assert ("date ok", d.day = 6 and d.month = 5 and d.year = 2022)
			end
			if attached entry.time as t then
				assert ("time ok", t.hour = 14 and t.minute = 25 and t.second = 51)
			end
			assert_same_string (Void, Ip_address.to_string (entry.ip_number), "86.41.71.251")
			assert_same_string (Void, entry.http_command, "GET")
			assert_same_string (Void, entry.request_uri, request_uri)
			assert_same_string (Void, entry.referer, referer)
			assert_same_string (Void, entry.user_agent, user_agent)
			assert_same_string (Void, entry.normalized_user_agent, "firefox linux rv x11 x86_64")

			assert ("status code ok", entry.status_code = 200)
			assert ("byte_count ok", entry.byte_count = 20346)
		end

end