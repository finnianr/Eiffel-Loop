note
	description: "Date text test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 11:55:46 GMT (Friday 24th January 2020)"
	revision: "9"

class
	DATE_TEXT_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_DATE

feature -- Tests

	test_from_iso_8601_formatted
		local

		do
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted ("20171123T155101Z"))
		end

	test_from_canonical_iso_8601_formatted
		local

		do
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted ("2017-11-23T15:51:01Z"))
		end

	test_formatted_date
		note
			testing: "covers/{EL_TEMPLATE}.make, covers/{EL_TEMPLATE}.substituted"
		local
			date_text: EL_ENGLISH_DATE_TEXT
			canonical_format: ZSTRING
		do
			create date_text.make
			canonical_format := date_text.formatted (Date_time.date, {EL_DATE_FORMATS}.canonical)
			assert ("Same date string", canonical_format.same_string (Date_string))
		end

feature {NONE} -- Constants

	Date_string: STRING = "Thursday 23rd November 2017"

	Date_time: DATE_TIME
		-- Thursday 23rd Nov 2017
		once
			create Result.make (2017, 11, 23, 15, 51, 01)
		end

end
