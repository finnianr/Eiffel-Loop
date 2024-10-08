note
	description: "Factory for date-time string parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 7:34:07 GMT (Tuesday 27th August 2024)"
	revision: "12"

class
	EL_DATE_TIME_CODE_STRING

inherit
	DATE_TIME_CODE_STRING
		rename
			create_string as new_string,
			create_date as new_date,
			create_date_time as new_date_time,
			create_time_string as new_time_string,
			create_time as new_time
		export
			{EL_DATE_TIME_PARSER} days, months, base_century
		redefine
			correspond, make
		end

	EL_STRING_HANDLER

	EL_MODULE_DATE_TIME

	EL_STRING_8_CONSTANTS


create
	make

feature {NONE} -- Initialization

	make (format: STRING)
		do
			Precursor (adjusted_format (format))
		ensure then
			format_count_unchange: old format.count = format.count
		end

feature -- Access

	new_parser: EL_DATE_TIME_PARSER
		do
			create Result.make (Current)
		end

feature -- Status query

	correspond (str: STRING): BOOLEAN
		do
			if attached Buffer.copied_upper (adjusted_format (str)) as adjusted then
				Result := Precursor (adjusted)
			end
		end

feature -- Basic operations

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
					if attached Buffer.empty as padded_4 then
						from padded_4.append_integer (date.year) until padded_4.count = 4 loop
							append_zeros (padded_4, 1)
						end
						str.append (padded_4)
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
					if attached Buffer.empty as padded then
						padded.append_integer (double.rounded)
						if padded.count < l_item.count_max then
							append_zeros (str, l_item.count_max - padded.count)
						end
						str.append (padded)
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
		end

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

	adjusted_format (str: STRING): STRING
		-- `format' with time zone designators removed
		do
			Result := str
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end