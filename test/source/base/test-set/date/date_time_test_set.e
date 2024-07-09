note
	description: "Date text test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 16:57:38 GMT (Tuesday 9th July 2024)"
	revision: "40"

class
	DATE_TIME_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DATE; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_TUPLE

	TIME_VALIDITY_CHECKER undefine default_create end

	EL_SHARED_DATE_FORMAT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["compact_decimal_time",				  agent test_compact_decimal_time],
				["date_time",								  agent test_date_time],
				["date_time_proper_case",				  agent test_date_time_proper_case],
				["date_time_subtract",					  agent test_date_time_subtract],
				["date_time_update",						  agent test_date_time_update],
				["epoch_date_time",						  agent test_epoch_date_time],
				["execution_timer",						  agent test_execution_timer],
				["formatted_date",						  agent test_formatted_date],
				["from_canonical_iso_8601_formatted", agent test_from_canonical_iso_8601_formatted],
				["from_iso_8601_formatted",			  agent test_from_iso_8601_formatted],
				["time_input_formats",					  agent test_time_input_formats],
				["time_zone_designator",				  agent test_time_zone_designator],
				["time_format_out",						  agent test_time_format_out]
			>>)
		end

feature -- Tests

	test_compact_decimal_time
		-- DATE_TIME_TEST_SET.test_compact_decimal_time
		note
			testing: "[
				covers/{EL_TIME_ROUTINES}.compact_decimal,
				covers/{EL_TIME_ROUTINES}.set_from_compact_decimal,
				covers/{EL_TIME_ROUTINES}.same_time
			]"
		local
			t1, t2: EL_TIME; time: EL_TIME_ROUTINES; double: EL_DOUBLE_MATH
		do
			create t1.make_from_string ("3:08:01.947 PM")
			create t2.make_by_compact_decimal (time.compact_decimal (t1))
			assert ("same time", t1.compact_time = t2.compact_time)
			assert ("same time", time.same_time (t1, t2))
			assert ("same fractional second", double.approximately_equal (t1.fractional_second, t2.fractional_second, 0.000_000_1))
			assert_approximately_equal ("same fractional second", 7, t1.fractional_second, t2.fractional_second)

			create t1.make_by_seconds (0)
			assert ("NATURAL_16 fraction is zero", time.fractional_secs_23_bit (t1) = 0)
		end

	test_date_time
		-- DATE_TIME_TEST_SET.test_date_time
		local
			dt: EL_DATE_TIME; l_date: EL_DATE; l_time: EL_TIME
		do
			create l_time.make_with_format ("01:15:20", "[0]hh:[0]mi:[0]ss")
			assert ("same hour", l_time.hour = 1)
			assert ("same minute", l_time.minute = 15)
			assert ("same second", l_time.second = 20)

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

	test_date_time_update
		note
			testing: "[
				covers/{EL_SYSTEM_TIME}.update,
				covers/{EL_TIME_DATE_I}.make_now,
				covers/{EL_TIME_DATE_I}.update,
				covers/{EL_DATE}.update_with,
				covers/{EL_TIME}.update_with,
				covers/{EL_DATE_TIME}.update_with
			]"
		local
			d_1: DATE; d_2: EL_DATE; t_1: TIME; t_2: EL_TIME
			dt_1: DATE_TIME; dt_2: EL_DATE_TIME
		do
			create dt_1.make_now; create dt_2.make_now
			assert ("same date", dt_1.date.ordered_compact_date = dt_2.date.ordered_compact_date)
			assert ("same time", dt_1.time.compact_time = dt_2.time.compact_time)

			create d_1.make_now; create d_2.make_now
			assert ("same date", d_1.ordered_compact_date = d_2.ordered_compact_date)

			create t_1.make_now; create t_2.make_now
			assert ("same date", t_1.compact_time = t_2.compact_time)
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

	test_execution_timer
		-- DATE_TIME_TEST_SET.test_execution_timer
		note
			testing: "[
				covers/{EL_SYSTEM_TIME}.update,
				covers/{EL_EXECUTION_TIMER}.make,
				covers/{EL_EXECUTION_TIMER}.start,
				covers/{EL_EXECUTION_TIMER}.stop,
				covers/{EL_EXECUTION_TIMER}.resume
			]"
		local
			timer: EL_EXECUTION_TIMER; matched: BOOLEAN
			secs_string: STRING
		do
			create timer.make
			across 1 |..| 5 as n loop
				timer.resume
				execution.sleep (200)
				timer.stop
				execution.sleep (20)
			end
			secs_string := "1 secs 0 ms"
			across "01" as digit until matched loop
				secs_string [secs_string.count - 3] := digit.item
				matched := timer.elapsed_time.out ~ secs_string
			end
			assert ("1 sec elapsed give or take 1 ms", matched)
		end

	test_formatted_date
		-- DATE_TIME_TEST_SET.test_formatted_date
		note
			testing: "[
				covers/{EL_TEMPLATE}.make,
				covers/{EL_TEMPLATE}.substituted
			]"
		local
			date_text: EL_DATE_TEXT; canonical_format: ZSTRING
		do
			create date_text.make_default
			canonical_format := date_text.formatted (Date_time.date, Date_format.canonical)
			assert ("Same date string", canonical_format.same_string_general (Date_2017.spelled))
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

	test_time_input_formats
		local
			from_time, to_time: TIME; l_duration: TIME_DURATION
			l_format, from_str, to_str: STRING
		do
			l_format := "[0]mi:[0]ss.ff3"
			from_str := "01:01.500"; to_str := "01:03.001"
			if is_valid_time (from_str) and is_valid_time (to_str) then
				if time_valid (from_str, l_format) and time_valid (to_str, l_format) then
					create from_time.make_from_string (from_str, l_format)
					create to_time.make_from_string (to_str, l_format)
					lio.put_labeled_string ("From", from_str); lio.put_labeled_string (" to", to_str)
					lio.put_new_line
					lio.put_labeled_string ("From", from_time.out); lio.put_labeled_string (" to", to_time.out)
					lio.put_new_line
					l_duration := to_time.relative_duration (from_time)
					lio.put_double_field ("Fine seconds", l_duration.fine_seconds_count, Void)
				else
					assert ("Bug in `time_valid' precondition routine", True)
				end
			else
				failed ("Invalid time format")
			end
		end

	test_time_zone_designator
		local
			dt, utc: EL_DATE_TIME
		do
			create utc.make (2016, 4, 10, 2, 35, 1)
			create dt.make_with_format ("19:35:01 Apr 09, 2016 PST+1", "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy tzd")
			assert ("same as UTC", dt ~ utc)

			create dt.make_with_format ("Sun Apr 9 2016 19:35:01 GMT-0700 (GMT)", "Ddd Mmm dd yyyy [0]hh:[0]mi:[0]ss tzd (tzd)")
			assert ("same as UTC", dt ~ utc)

			create dt.make_with_format ("Wed, 7 Jul 2021 13:11:02 +0100", "Ddd, dd Mmm yyyy [0]hh:[0]mi:[0]ss tzd")
			create utc.make (2021, 7, 7, 12, 11, 2)
			assert ("same as UTC", dt ~ utc)
		end

feature -- Observation Tests

	test_time_format_out
		local
			now: DATE_TIME; const: DATE_CONSTANTS; day_text: ZSTRING
		do
			create const
			create now.make_now
			day_text := const.days_text.item (now.date.day_of_the_week)
			day_text.to_proper
			lio.put_labeled_string ("Time", day_text + now.formatted_out (", yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss") + " GMT")
			lio.put_new_line
		end

feature {NONE} -- Implementation

	is_valid_time (str: STRING): BOOLEAN
		local
			parts: LIST [STRING]; mins, secs: STRING
		do
			parts := str.split (':')
			if parts.count = 2 then
				mins := parts [1]; secs := parts [2]
				secs.prune_all_leading ('0')
				Result := mins.is_integer and secs.is_real
			end
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