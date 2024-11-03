note
	description: "Factory for date-time string parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-03 18:31:23 GMT (Sunday 3rd November 2024)"
	revision: "13"

class
	EL_DATE_TIME_CODE_STRING

inherit
	DATE_TIME_CODE_STRING
		rename
			create_string as new_string,
			create_date as new_date,
			create_date_time as new_date_time,
			create_time_string as new_time_string,
			create_time as new_time,
			value as code_table
		export
			{EL_DATE_TIME_PARSER} days, months, base_century
		redefine
			correspond, make
		end

	DATE_TIME_TOOLS
		rename
			name as language_name
		export
			{NONE} all
		end

	EL_STRING_HANDLER

	EL_MODULE_DATE_TIME

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (format: STRING)
		local
			substr_1, substr_2, str: STRING; case: NATURAL_8
			code: DATE_TIME_CODE; i, pos1, pos2: INTEGER
		do
			str := adjusted_format (format)
			create code_table.make (20)
			create case_table.make_filled ({EL_CASE}.upper, {DTC}.day_text_type_code, {DTC}.month_text_type_code)
			pos1 := 1; pos2 := 1
			days := days_text.twin; months := months_text.twin
			from i := 1 until pos1 >= str.count loop
				pos2 := find_separator (str, pos1)
				if attached extracted_substrings (str, pos1, pos2) as extracted then
					pos2 := abs (pos2)
					substr_1 := extracted.substrg
					case := case_type (substr_1); substr_1.to_lower
					if substr_1.count > 0 then
						create code.make (substr_1)
						code_table.put (code, i)
						if case = {EL_CASE}.proper and then case_table.valid_index (code.type) then
							case_table [code.type] := {EL_CASE}.proper
						end
						i := i + 1
					end
					substr_2 := extracted.substrg2
					if substr_2.count > 0 then
						code_table.put (create {DATE_TIME_CODE}.make (substr_2), i)
						i := i + 1
						separators_used := True
					end
				end
				pos1 := pos2 + 1
			end
			base_century := (create {C_DATE}).year_now // 100 * -100
				-- A negative value of `base_century' indicates that it has
				-- been calculated automatically, therefore '* -100'.
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

	append_to (str: STRING; a_date_time: DATE_TIME)
			-- Create the output of `dt' according to the code string.
		local
			date: DATE; time: TIME; int, i: INTEGER; double: DOUBLE
			break: BOOLEAN
		do
			date := a_date_time.date; time := a_date_time.time
			from i := 1 until break loop
				if attached code_table [i] as dtc then
					inspect dtc.type
						when {DTC}.day_numeric_type_code then
							str.append_integer (date.day)

						when {DTC}.day_numeric_on_2_digits_type_code then
							append_2_digits (str, date.day)

						when {DTC}.day_text_type_code then
							append_array_text (str, dtc.type, date.day_of_the_week, days)

						when {DTC}.year_on_4_digits_type_code then
							-- Test if the year has four digits, if not put 0 to fill it
							if attached Buffer.empty as padded_4 then
								from padded_4.append_integer (date.year) until padded_4.count = 4 loop
									append_zeros (padded_4, 1)
								end
								str.append (padded_4)
							end
						when {DTC}.year_on_2_digits_type_code then
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
						when {DTC}.month_numeric_type_code then
							str.append_integer (date.month)

						when {DTC}.month_numeric_on_2_digits_type_code then
							append_2_digits (str, date.month)

						when {DTC}.month_text_type_code then
							append_array_text (str, dtc.type, date.month, months)

						when {DTC}.hour_numeric_type_code then
							str.append_integer (time.hour)

						when {DTC}.hour_numeric_on_2_digits_type_code then
							append_2_digits (str, time.hour)

						when {DTC}.hour_12_clock_scale_type_code, {DTC}.hour_12_clock_scale_on_2_digits_type_code then
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
							if dtc.type = {DTC}.hour_12_clock_scale_on_2_digits_type_code then
									-- Format padded with 0.
								append_2_digits (str, int)
							else
								str.append_integer (int)
							end
						when {DTC}.minute_numeric_type_code then
							str.append_integer (time.minute)

						when {DTC}.minute_numeric_on_2_digits_type_code then
							append_2_digits (str, time.minute)

						when {DTC}.second_numeric_type_code then
							str.append_integer (time.second)

						when {DTC}.second_numeric_on_2_digits_type_code then
							append_2_digits (str, time.second)

						when {DTC}.fractional_second_numeric_type_code then
							double := time.fractional_second * 10 ^ (dtc.count_max)
							if attached Buffer.empty as padded then
								padded.append_integer (double.rounded)
								if padded.count < dtc.count_max then
									append_zeros (str, dtc.count_max - padded.count)
								end
								str.append (padded)
							end
						when {DTC}.meridiem_type_code then
							int := time.hour
							if int < 12 then
								str.append (once "AM")
							else
								str.append (once "PM")
							end
					else
						str.append (dtc.value)
					end
					i := i + 1
				else
					break := True
				end
			end
		end

feature {NONE} -- Implementation

	adjusted_format (str: STRING): STRING
		-- `format' with time zone designators removed
		do
			Result := str
		end

	append_2_digits (str: STRING; n: INTEGER)
		require
			valid_digits: n < 100
		do
			if n < 10 then
				append_zeros (str, 1)
			end
			str.append_integer (n)
		end

	append_array_text (str: STRING; code_type, index: INTEGER; array: ARRAY [STRING])
		require
			valid_index: array.valid_index (index)
		local
			i: INTEGER; s: EL_STRING_8_ROUTINES
		do
			str.append (array [index])
			if case_table.valid_index (code_type) and then case_table [code_type] = {EL_CASE}.Proper then
				from i := str.count until i < str.count - 1 loop
					s.set_lower (str, i)
					i := i - 1
				end
			end
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

	case_type (code: STRING): NATURAL_8
		do
			if code.count = 3 then
				if code [1].is_upper and code [2].is_lower then
					Result := {EL_CASE}.Proper
				else
					Result := {EL_CASE}.UPPER
				end
			end
		end

feature {NONE} -- Initialization

	case_table: ARRAY [NATURAL_8]

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end