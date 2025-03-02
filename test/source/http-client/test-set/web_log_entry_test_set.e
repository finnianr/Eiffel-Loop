note
	description: "Test class ${EL_WEB_LOG_ENTRY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-01 9:39:37 GMT (Saturday 1st March 2025)"
	revision: "6"

class
	WEB_LOG_ENTRY_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

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
		note
			testing: "[
				covers/{EL_WEB_LOG_ENTRY}.make,
				covers/{EL_DATE_TIME_PARSER}.to_ordered_compact_date,
				covers/{EL_DATE_TIME_PARSER}.to_compact_time,
				covers/{EL_IP_ADDRESS_ROUTINES}.substring_as_number
			]"
		local
			entry: EL_WEB_LOG_ENTRY; template: EL_TEMPLATE [STRING]
		do
			create template.make ("[
				$address - - [$date_time] "GET $request_uri HTTP/1.1" 200 20346 "$referer" "$user_agent"
			]")
			template.put ("address", Field.address)
			template.put ("date_time", Field.date_time)
			template.put ("referer", Field.referer)
			template.put ("request_uri", Field.request_uri)
			template.put ("user_agent", Field.user_agent)
			create entry.make (template.substituted)

			if attached entry.date as d then
				assert ("date ok", d.day = 6 and d.month = 5 and d.year = 2022)
			end
			if attached entry.time as t then
				assert ("time ok", t.hour = 14 and t.minute = 25 and t.second = 51)
			end
			assert ("is_absolute_uri", entry.is_absolute_uri)

			assert_same_string (Void, Ip_address.to_string (entry.ip_number), Field.address)
			assert_same_string (Void, entry.http_command, "GET")
			assert_same_string (Void, entry.request_uri, Field.request_uri)
			assert_same_string (Void, entry.referer, Field.referer)
			assert_same_string (Void, entry.uri_extension, "html")
			assert_same_string (Void, entry.uri_step, "en")
			assert_same_string (Void, entry.user_agent, Field.user_agent)
			assert_same_string (Void, entry.normalized_user_agent, "firefox linux rv x11 x86_64")

			assert ("status code ok", entry.status_code = 200)
			assert ("byte_count ok", entry.byte_count = 20346)
		end

feature {NONE} -- Constants

	Field: TUPLE [address, date_time, request_uri, referer, user_agent: STRING]
		once
			create Result
			Tuple.line_fill (Result, "[
				86.41.71.251
				06/May/2022:14:25:51 +0000
				/en/home.html
				http://matryoshka.software/en/purchase.html
				Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
			]")
		end


end