note
	description: "Date time experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-14 9:38:24 GMT (Saturday 14th August 2021)"
	revision: "4"

class
	DATE_TIME_EXPERIMENTS

inherit
	EXPERIMENTAL

feature -- Basic operations

	duration
		local
			this_year, last_year, now: DATE_TIME; elapsed: EL_TIME_DURATION
			timer: EL_EXECUTION_TIMER
		do
			create this_year.make (2017, 6, 11, 23, 10, 10)
			create last_year.make (2016, 6, 11, 23, 10, 10)

			lio.put_integer_field ("Year days", this_year.relative_duration (last_year).date.day)
			lio.put_new_line

			create now.make_now
			create elapsed.make_by_fine_seconds (now.relative_duration (this_year).fine_seconds_count)
			lio.put_labeled_string ("TIME", elapsed.out)
			lio.put_new_line

			create timer.make
			lio.put_labeled_string ("TIME", timer.elapsed_time.out)
			lio.put_new_line
			timer.start
			execution.sleep (500)
			timer.stop
			timer.resume
			execution.sleep (500)
			timer.stop
			lio.put_labeled_string ("TIME", timer.elapsed_time.out)
		end

	format
		local
			now: DATE_TIME; const: DATE_CONSTANTS; day_text: ZSTRING
		do
			create const
			create now.make_now
			day_text := const.days_text.item (now.date.day_of_the_week)
			day_text.to_proper_case
			lio.put_labeled_string ("Time", day_text + now.formatted_out (", yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss") + " GMT")
			lio.put_new_line
		end

	make_date
		local
			date_1, date_2, date_3: DATE_TIME; date_iso: EL_SHORT_ISO_8601_DATE_TIME
		do
			create date_1.make_from_string ("20171216113300", "yyyy[0]mm[0]dd[0]hh[0]mi[0]ss")
			create date_2.make_from_string ("2017-12-16 11:33:00", "yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss") -- Fails
			create date_iso.make ("20171216T113300Z")
			create date_3.make_from_string ("19:35:01 Apr 09, 2016", "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy")
		end

	time_input_formats
		local
			from_time, to_time: TIME; l_duration: TIME_DURATION
			l_format, from_str, to_str: STRING
		do
			l_format := "mi:ss.ff3"
--			from_str := "1:01.500"; to_str := "1:03.001"
			from_str := "0:05.452"; to_str := "5:34.49"
			if is_valid_time (from_str) and is_valid_time (to_str) then
				create from_time.make_from_string (from_str, l_format)
				create to_time.make_from_string (to_str, l_format)
				lio.put_labeled_string ("From", from_str); lio.put_labeled_string (" to", to_str)
				lio.put_new_line
				lio.put_labeled_string ("From", from_time.out); lio.put_labeled_string (" to", to_time.out)
				lio.put_new_line
				l_duration := to_time.relative_duration (from_time)
				lio.put_double_field ("Fine seconds", l_duration.fine_seconds_count)
			else
				lio.put_line ("Invalid time format")
			end
		end

	time_parsing
		local
			time_str, l_format: STRING; time: TIME
			checker: TIME_VALIDITY_CHECKER
		do
			time_str := "21:15"; l_format := "hh:mi"
			create checker
			if True or checker.time_valid (time_str, l_format) then
				create time.make_from_string (time_str, l_format)
			else
				create time.make (0, 0, 0)
			end
			lio.put_labeled_string ("Time", time.formatted_out ("hh:[0]mi"))
			lio.put_new_line
		end

	validity_check
		local
			checker: DATE_VALIDITY_CHECKER; str: STRING
		do
			create checker
			str := "2015-12-50"
			lio.put_labeled_string (str, checker.date_valid (str, "yyyy-[0]mm-[0]dd").out)
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

end