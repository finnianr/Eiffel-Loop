note
	description: "Factory for date-time string parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-13 9:58:59 GMT (Friday 13th August 2021)"
	revision: "6"

class
	EL_DATE_TIME_CODE_STRING

inherit
	DATE_TIME_CODE_STRING
		rename
			create_string as new_string,
			create_date as new_date,
			create_date_time as new_date_time,
			create_time_string as new_time_string
		redefine
			correspond, make
		end

	EL_MODULE_DATE_TIME

	EL_STRING_8_CONSTANTS

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make (format: STRING)
		do
			set_zone_designator_count (format)
			Precursor (cropped_format (format))
		ensure then
			format_count_unchange: old format.count = format.count
		end

feature -- Access

	correspond (format: STRING): BOOLEAN
		do
			Result := Precursor (cropped_format (format))
		end

	new_parser: EL_DATE_TIME_PARSER
		do
			create Result.make (value)
			Result.set_day_array (days)
			Result.set_month_array (months)
			Result.set_base_century (base_century)
			Result.set_zone_dezignator_count (zone_designator_count)
		end

feature -- Basic operations

	append_date_to (str: STRING; date: DATE)
		do
			if attached Jan_1st_year_zero as dt then
				dt.date.make_by_ordered_compact_date (date.ordered_compact_date)
				append_to (str, dt)
			end
		end

	append_time_to (str: STRING; time: TIME)
		do
			if attached Jan_1st_year_zero as dt then
				dt.time.make_by_fine_seconds (time.fine_seconds)
				append_to (str, dt)
			end
		end

	append_to (str: STRING; dt: DATE_TIME)
			-- Create the output of `dt' according to the code string.
		local
			date: DATE; time: TIME; int, i, type: INTEGER; double: DOUBLE
			l_item: detachable DATE_TIME_CODE
		do
			date := dt.date; time := dt.time
			from
				i := 1
				l_item := value.item (i)
			until
				l_item = Void
			loop
				type := l_item.type
				inspect
					type
				when {DATE_TIME_CODE}.day_numeric_type_code then
					str.append_integer (date.day)

				when {DATE_TIME_CODE}.day_numeric_on_2_digits_type_code then
					append_2_digits (str, date.day)

				when {DATE_TIME_CODE}.day_text_type_code then
					append_text (str, date.day_of_the_week, days)

				when {DATE_TIME_CODE}.year_on_4_digits_type_code then
					-- Test if the year has four digits, if not put 0 to fill it
					if attached Buffer.empty as tmp then
						from tmp.append_integer (date.year) until tmp.count = 4 loop
							append_zeros (tmp, 1)
						end
						str.append (tmp)
					end
				when {DATE_TIME_CODE}.year_on_2_digits_type_code then
						-- Two digit year, we only keep the last two digits
					if attached Buffer.empty as tmp then
						tmp.append_integer (date.year)
						if tmp.count > 2 then
							tmp.keep_tail (2)
						elseif tmp.count = 1 then
							append_zeros (str, 1)
						end
						str.append (tmp)
					end
				when {DATE_TIME_CODE}.month_numeric_type_code then
					str.append_integer (date.month)

				when {DATE_TIME_CODE}.month_numeric_on_2_digits_type_code then
					append_2_digits (str, date.month)

				when {DATE_TIME_CODE}.month_text_type_code then
					append_text (str, date.month, months)

				when {DATE_TIME_CODE}.hour_numeric_type_code then
					str.append_integer (time.hour)

				when {DATE_TIME_CODE}.hour_numeric_on_2_digits_type_code then
					append_2_digits (str, time.hour)

				when {DATE_TIME_CODE}.hour_12_clock_scale_type_code, {DATE_TIME_CODE}.hour_12_clock_scale_on_2_digits_type_code then
					int := time.hour
					if int < 12 then
						if int = 0 then
							int := 12
						end
					else
						if int /= 12 then
							int := int - 12
						end
					end
					if type = {DATE_TIME_CODE}.hour_12_clock_scale_on_2_digits_type_code then
							-- Format padded with 0.
						append_2_digits (str, int)
					else
						str.append_integer (int)
					end
				when {DATE_TIME_CODE}.minute_numeric_type_code then
					str.append_integer (time.minute)

				when {DATE_TIME_CODE}.minute_numeric_on_2_digits_type_code then
					append_2_digits (str, time.minute)

				when {DATE_TIME_CODE}.second_numeric_type_code then
					str.append_integer (time.second)

				when {DATE_TIME_CODE}.second_numeric_on_2_digits_type_code then
					append_2_digits (str, time.second)

				when {DATE_TIME_CODE}.fractional_second_numeric_type_code then
					double := time.fractional_second * 10 ^ (l_item.count_max)
					if attached Buffer.empty as tmp then
						tmp.append_integer (double.rounded)
						if tmp.count < l_item.count_max then
							append_zeros (str, l_item.count_max - tmp.count)
						end
						str.append (tmp)
					end
				when {DATE_TIME_CODE}.meridiem_type_code then
					int := time.hour
					if int < 12 then
						str.append (once "AM")
					else
						str.append (once "PM")
					end
				else
					str.append (l_item.value)
				end
				i := i + 1
				l_item := value.item (i)
			end
			str.append (Zone_designator [zone_designator_count])
		ensure
			corresponds_to_format: correspond (str)
		end

feature -- Measurement

	zone_designator_count: INTEGER

feature {NONE} -- Implementation

	append_2_digits (str: STRING; n: INTEGER)
		require
			valid_digits: n < 100
		do
			if n < 10 then
				append_zeros (str, 1)
			end
			str.append_integer (n)
		end

	append_text (str: STRING; i: INTEGER; text_table: ARRAY [STRING])
		require
			valid_index: text_table.valid_index (i)
		do
			str.append (text_table [i])
		end

	append_zeros (str: STRING; n: INTEGER)
		local
			i: INTEGER
		do
			from i := 1 until i > n loop
				str.append_character ('0')
				i := i + 1
			end
		end

	cropped_format (format: STRING): STRING
		-- `format' with time zone designators removed
		local
			s: EL_STRING_8_ROUTINES
		do
			inspect zone_designator_count
				when 1, 2 then
					Result := Buffer.copied_substring (format, 1, s.leading_string_count (format, zone_designator_count))
			else
				Result := format
			end
		end

feature -- Element change

	set_zone_designator_count (format: STRING)
		do
			zone_designator_count := Date_time.zone_designator_count (format)
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Jan_1st_year_zero: DATE_TIME
		once
			create Result.make (1, 1, 1, 1, 1, 1)
		end

	Zone_designator: SPECIAL [STRING]
		once
			create Result.make_filled (Empty_string_8, 3)
			Result [1] := " UTC"
			Result [2] := " GMT+0000 (GMT)"
		end

end