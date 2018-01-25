note
	description: "Summary description for {DATE_TEXT_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 12:21:03 GMT (Saturday 16th December 2017)"
	revision: "2"

class
	DATE_TEXT_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_DATE
		undefine
			default_create
		end

feature -- Tests

	test_from_iso8601_formatted
		local

		do
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted ("20171123T155101Z"))
		end

	test_from_canonical_iso8601_formatted
		local

		do
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted ("2017-11-23T15:51:01Z"))
		end

feature {NONE} -- Constants

	Date_time: DATE_TIME
		once
			create Result.make (2017, 11, 23, 15, 51, 01)
		end

end
