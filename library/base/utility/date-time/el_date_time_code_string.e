note
	description: "Factory for date-time string parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-15 9:34:29 GMT (Saturday 15th May 2021)"
	revision: "2"

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

	EL_SHARED_DATE_TIME

create
	make

feature {NONE} -- Initialization

	make (s: STRING)
		local
			str: STRING; i, zone_index: INTEGER
		do
			str := s.as_upper
			zone_index := str.substring_index (Time_zone_dezignator, 1)
			if zone_index.to_boolean then
				if str.substring_index (Time_zone_dezignator, zone_index + 3).to_boolean then
					zone_dezignator_count := 2
				else
					zone_dezignator_count := 1
				end
				from i := zone_index - 1 until s [i].is_space or else i = 0 loop
					i := i - 1
				end
				Precursor (s.substring (1, i - 1))
			else
				Precursor (s)
			end
		end

feature -- Access

	new_parser: EL_DATE_TIME_PARSER
			-- Parser from `s'.
			-- Build a new one if necessary.
		do
			create Result.make (value)
			Result.set_day_array (days)
			Result.set_month_array (months)
			Result.set_base_century (base_century)
			Result.set_zone_dezignator_count (zone_dezignator_count)
		end

feature -- Interface

	correspond (s: STRING): BOOLEAN
		local
			leading_count: INTEGER
		do
			if zone_dezignator_count.to_boolean then
				leading_count := Date_time.leading_string_count (s, zone_dezignator_count)
				Result := Precursor (Buffer.copied_substring (s, 1, leading_count))
			else
				Result := Precursor (s)
			end
		end

feature {NONE} -- Internal attributes

	zone_dezignator_count: INTEGER

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Time_zone_dezignator: STRING = "TZD"
end