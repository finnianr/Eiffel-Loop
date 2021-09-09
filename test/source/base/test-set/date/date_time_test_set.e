note
	description: "Date text test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-07 15:29:02 GMT (Tuesday 7th September 2021)"
	revision: "18"

class
	DATE_TIME_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DATE

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("date_time", agent test_date_time)
			eval.call ("date_time_proper_case", agent test_date_time_proper_case)
			eval.call ("date_time_subtract", agent test_date_time_subtract)
			eval.call ("epoch_date_time", agent test_epoch_date_time)
			eval.call ("formatted_date", agent test_formatted_date)
			eval.call ("from_canonical_iso_8601_formatted", agent test_from_canonical_iso_8601_formatted)
			eval.call ("from_iso_8601_formatted", agent test_from_iso_8601_formatted)
			eval.call ("time_zone_designator", agent test_time_zone_designator)
		end

feature -- Tests

	test_date_time
		local
			dt: EL_DATE_TIME; l_date: EL_DATE; l_time: EL_TIME
		do
			create dt.make_with_format (Date_time.formatted_out (Format_date_time), Format_date_time)
			create l_date.make_from_string (dt.date.out)
			create l_time.make_from_string (dt.time.out)

			assert ("same date time", dt ~ Date_time)
			assert ("same date", l_date.same_as (dt.date))
			assert ("same time", l_time.same_as (dt.time))
		end

	test_date_time_proper_case
		local
			dt: EL_DATE_TIME
		do
			create dt.make_with_format ("15:51:01 Nov 23, 2017", "[0]hh:[0]mi:[0]ss mmm [0]dd, yyyy")
			assert ("same date", dt ~ Date_time)
			assert ("same propercase month", "15:51:01 Nov 23, 2017" ~ dt.formatted_out ("[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy"))
			assert ("same string", "15:51:01 NOV 23, 2017" ~ dt.formatted_out ("[0]hh:[0]mi:[0]ss mmm [0]dd, yyyy"))
		end

	test_date_time_subtract
		local
			dt, dt_2: EL_DATE_TIME
		do
			create dt.make (2000, 1, 3, 1, 0, 0)
			create dt_2.make (2000, 1, 2, 23, 0, 0)
			dt.hour_add (-2)
			assert ("substracting 2 hours is 11 PM previous day", dt ~ dt_2)
		end

	test_epoch_date_time
		local
			dt, dt_2: EL_DATE_TIME
		do
			create dt.make (2000, 1, 3, 1, 0, 0)
			create dt_2.make_from_epoch (dt.epoch_seconds)
			assert ("same date", dt.is_almost_equal (dt_2))

			create dt.make_from_string ("09/07/2021 3:08:01.947 PM")
			create dt_2.make_from_epoch (dt.epoch_seconds)
			assert ("same date", dt.is_almost_equal (dt_2))
		end

	test_formatted_date
		note
			testing: "covers/{EL_TEMPLATE}.make, covers/{EL_TEMPLATE}.substituted"
		local
			date_text: EL_ENGLISH_DATE_TEXT; canonical_format: ZSTRING
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
			create dt.make_iso_8601_extended (Date_2017.ISO_8601)
			assert ("same time", date_time.out ~ dt.out)
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted (Date_2017.ISO_8601))
			assert ("same time", date_time ~ Date.from_ISO_8601_formatted (Date_2017.ISO_8601_short))
		end

	test_time_zone_designator
		local
			dt, dt_2: EL_DATE_TIME
		do
			create dt_2.make (2016, 4, 10, 2, 35, 1)
			create dt.make_with_format ("19:35:01 Apr 09, 2016 PST+1", "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy tzd")
			assert ("same date", dt ~ dt_2)

			create dt.make_with_format ("Sun Apr 9 2016 19:35:01 GMT-0700 (GMT)", "Ddd Mmm dd yyyy [0]hh:[0]mi:[0]ss tzd (tzd)")
			assert ("same GMT date", dt ~ dt_2)
		end

feature {NONE} -- Constants

	Date_2017: TUPLE [ISO_8601, ISO_8601_short, spelled: STRING]
		once
			create Result
			Tuple.fill (Result, "2017-11-23T15:51:01Z, 20171123T155101Z, Thursday 23rd November 2017")
		end

	Date_time: EL_DATE_TIME
		-- Thursday 23rd Nov 2017
		once
			create Result.make (2017, 11, 23, 15, 51, 01)
		end

	Format_date_time: STRING =	"yyyy/[0]mm/[0]dd [0]hh:[0]mi:[0]ss"

end