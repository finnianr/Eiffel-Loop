note
	description: "Date text test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 15:22:20 GMT (Thursday 13th May 2021)"
	revision: "11"

class
	DATE_TEXT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DATE

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("from_iso_8601_formatted", agent test_from_iso_8601_formatted)
			eval.call ("from_canonical_iso_8601_formatted", agent test_from_canonical_iso_8601_formatted)
			eval.call ("formatted_date", agent test_formatted_date)
			eval.call ("date_time", agent test_date_time)
		end

feature -- Tests

	test_date_time
		local
			dt: DATE_TIME
		do
			create dt.make_from_string (Date_time.formatted_out (Format_date_time), Format_date_time)
			assert ("same date", dt ~ Date_time)
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
			assert ("Same date string", canonical_format.same_string (Date_2017.spelled))
		end

	test_from_canonical_iso_8601_formatted
		do
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted (Date_2017.ISO_8601))
		end

	test_from_iso_8601_formatted
		local
			dt: EL_DATE_TIME
		do
			create dt.make_iso_8601 (Date_2017.ISO_8601)
			assert ("same time", date_time.out ~ dt.out)
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted (Date_2017.ISO_8601))
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted (Date_2017.ISO_8601_short))
		end

feature {NONE} -- Constants

	Date_2017: TUPLE [ISO_8601, ISO_8601_short, spelled: STRING]
		once
			create Result
			Tuple.fill (Result, "2017-11-23T15:51:01Z, 20171123T155101Z, Thursday 23rd November 2017")
		end

	Date_time: DATE_TIME
		-- Thursday 23rd Nov 2017
		once
			create Result.make (2017, 11, 23, 15, 51, 01)
		end

	Format_date_time: STRING =	"yyyy/[0]mm/[0]dd [0]hh:[0]mi:[0]ss"

end