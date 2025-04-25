note
	description: "Factory for date-time string parsing"
	descendants: "[
			EL_DATE_TIME_CODE_STRING
				${EL_ZONED_DATE_TIME_CODE_STRING}
				${EL_ISO_8601_DATE_TIME_CODE_STRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 16:25:24 GMT (Friday 25th April 2025)"
	revision: "16"

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

	EL_MODULE_DATE_TIME; EL_MODULE_FORMAT

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_format: STRING)
		local
			str: STRING; case: NATURAL_8; code: DATE_TIME_CODE; i, index_1, index_2: INTEGER
		do
			str := adjusted_format (a_format)
			create code_table.make (20)
			create case_table.make_filled ({EL_CASE}.upper, {DTC}.day_text_type_code, {DTC}.month_text_type_code)
			index_1 := 1; index_2 := 1
			days := days_text.twin; months := months_text.twin
			from i := 1 until index_1 >= str.count loop
				index_2 := find_separator (str, index_1)
				if attached extracted_substrings (str, index_1, index_2) as extracted then
					index_2 := abs (index_2)
					case := case_type (extracted.substrg) -- before `to_lower' called
					across << extracted.substrg, extracted.substrg2 >> as array loop
						if attached array.item as substring then
							if array.is_first then
								substring.to_lower
							end
							if substring.count > 0 then
								create code.make (substring)
								code_table.put (code, i)
								if array.is_first then
									if case_table.valid_index (code.type) then
										case_table [code.type] := case
									end
								else
									separators_used := True
								end
								i := i + 1
							end
						end
					end
				end
				index_1 := index_2 + 1
			end
			base_century := (create {C_DATE}).year_now // 100 * -100
				-- A negative value of `base_century' indicates that it has
				-- been calculated automatically, therefore '* -100'.
		ensure then
			format_count_unchange: old a_format.count = a_format.count
		end

feature -- Access

	new_parser: EL_DATE_TIME_PARSER
		do
			create Result.make (Current)
		end

feature -- Status query

	correspond (str: STRING): BOOLEAN
		do
			Result := Precursor (adjusted_format (str).as_upper)
		end

feature -- Basic operations

	append_to (str: STRING; a_date_time: DATE_TIME)
		-- Create the output of `a_date_time' according to the code string.
		local
			i: INTEGER; break: BOOLEAN
		do
			from i := 1 until break loop
				if attached code_table [i] as dtc then
					append_code_to (str, dtc, a_date_time.date, a_date_time.time)
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

	append_code_to (str: STRING; dtc: DATE_TIME_CODE; date: DATE; time: TIME)
		local
			split_secs: INTEGER
		do
			inspect dtc.type
				when {DTC}.day_numeric_type_code then
					str.append_integer (date.day)

				when {DTC}.day_numeric_on_2_digits_type_code then
					Format.append_zero_padded (str, date.day, 2)

				when {DTC}.day_text_type_code then
					append_array_text (str, dtc.type, date.day_of_the_week, days)

				when {DTC}.year_on_4_digits_type_code then
					Format.append_zero_padded (str, date.year, 4)

				when {DTC}.year_on_2_digits_type_code then
					Format.append_zero_padded (str, date.year \\ 100, 2) -- Two digit year

				when {DTC}.month_numeric_type_code then
					str.append_integer (date.month)

				when {DTC}.month_numeric_on_2_digits_type_code then
					Format.append_zero_padded (str, date.month, 2)

				when {DTC}.month_text_type_code then
					append_array_text (str, dtc.type, date.month, months)

				when {DTC}.hour_numeric_type_code then
					str.append_integer (time.hour)

				when {DTC}.hour_numeric_on_2_digits_type_code then
					Format.append_zero_padded (str, time.hour, 2)

				when {DTC}.hour_12_clock_scale_type_code, {DTC}.hour_12_clock_scale_on_2_digits_type_code then
					inspect dtc.type
						when {DTC}.hour_12_clock_scale_on_2_digits_type_code then
							Format.append_zero_padded (str, max_12_hour (time.hour), 2)
					else
						str.append_integer (max_12_hour (time.hour))
					end
				when {DTC}.minute_numeric_type_code then
					str.append_integer (time.minute)

				when {DTC}.minute_numeric_on_2_digits_type_code then
					Format.append_zero_padded (str, time.minute, 2)

				when {DTC}.second_numeric_type_code then
					str.append_integer (time.second)

				when {DTC}.second_numeric_on_2_digits_type_code then
					Format.append_zero_padded (str, time.second, 2)

				when {DTC}.fractional_second_numeric_type_code then
					split_secs := (time.fractional_second * (10 ^ dtc.count_max)).rounded
					Format.append_zero_padded (str, split_secs, dtc.count_max)

				when {DTC}.meridiem_type_code then
					str.append (Anti_meridiem [time.hour < 12])
			else
				str.append (dtc.value)
			end
		end

	append_array_text (str: STRING; code_type, index: INTEGER; array: ARRAY [STRING])
		require
			valid_index: array.valid_index (index)
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			str.append (array [index])
			if case_table.valid_index (code_type) and then case_table [code_type] = {EL_CASE}.Proper then
				sg.super_8 (str).set_substring_lower (str.count - 1, str.count)
			end
		end

	case_type (code: STRING): NATURAL_8
		do
			if code.count = 3 and then (code [1].is_upper and code [2].is_lower) then
				Result := {EL_CASE}.Proper
			else
				Result := {EL_CASE}.UPPER
			end
		end

	max_12_hour (hour: INTEGER): INTEGER
		-- 24 hour -> 12 hour
		do
			inspect hour
				when 0 then
					Result := 12

				when 1 .. 12 then
					Result := hour
			else
				Result := hour - 12
			end
		end

feature {NONE} -- Initialization

	case_table: ARRAY [NATURAL_8]

feature {NONE} -- Constants

	Anti_meridiem: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("PM", "AM")
		end
end