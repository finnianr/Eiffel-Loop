note
	description: "Factory for date-time string parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 7:33:50 GMT (Wednesday 19th May 2021)"
	revision: "4"

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
			correspond, make, new_string
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
			zone_index := str.substring_index (Time_zone_designator, 1)
			if zone_index.to_boolean then
				if str.substring_index (Time_zone_designator, zone_index + 3).to_boolean then
					zone_designator_count := 2
				else
					zone_designator_count := 1
				end
				from i := zone_index - 1 until s [i].is_space or else i = 0 loop
					i := i - 1
				end
				Precursor (s.substring (1, i - 1))
			else
				Precursor (s)
			end
		ensure then
			valid_zone_designator_count: s.as_upper.has_substring (Time_zone_designator) implies zone_designator_count > 0
		end

feature -- Access

	new_parser: EL_DATE_TIME_PARSER
		do
			create Result.make (value)
			Result.set_day_array (days)
			Result.set_month_array (months)
			Result.set_base_century (base_century)
			Result.set_zone_dezignator_count (zone_designator_count)
		end

	new_string (dt: DATE_TIME): STRING
		local
			l_count: INTEGER
		do
			l_count := zone_designator_count
			zone_designator_count := 0
			Result := Precursor (dt) -- satisfy `correspond' post condition
			zone_designator_count := l_count

			inspect zone_designator_count
				when 1 then
					Result.append (once " UTC")
				when 2 then
					Result.append (once " GMT+0000 (GMT)")
			else
			end
		end

feature -- Measurement

	zone_designator_count: INTEGER

feature -- Interface

	correspond (s: STRING): BOOLEAN
		local
			leading_count: INTEGER
		do
			if zone_designator_count.to_boolean then
				leading_count := Date_time.leading_string_count (s, zone_designator_count)
				Result := Precursor (Buffer.copied_substring (s, 1, leading_count))
			else
				Result := Precursor (s)
			end
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Time_zone_designator: STRING = "TZD"
end