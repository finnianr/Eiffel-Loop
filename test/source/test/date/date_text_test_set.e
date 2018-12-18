note
	description: "Date text test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 18:28:24 GMT (Monday 17th December 2018)"
	revision: "4"

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

	test_formatted_date
		local
			date_text: EL_ENGLISH_DATE_TEXT
			canonical_format: ZSTRING
		do
			create date_text.make
			canonical_format := date_text.formatted (Date_time.date, {EL_DATE_FORMATS}.canonical)
			assert ("Is Thursday 23rd Nov 2017", canonical_format.same_string ("Thursday 23rd November 2017"))
		end

feature {NONE} -- Constants

	Date_time: DATE_TIME
		-- Thursday 23rd Nov 2017
		once
			create Result.make (2017, 11, 23, 15, 51, 01)
		end

end
