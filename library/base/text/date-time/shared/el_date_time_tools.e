note
	description: "Extension to [$source DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 13:41:42 GMT (Wednesday 8th November 2023)"
	revision: "13"

class
	EL_DATE_TIME_TOOLS

inherit
	DATE_TIME_TOOLS

	EL_MODULE_TUPLE

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature -- Access

	zone_designator_count (format: STRING): INTEGER
		-- 0 if format does not contain "tzd"
		-- 1 if format ends with "tzd"
		-- 2 if format ends with "tzd (tzd)"
		local
			zone_index: INTEGER; format_upper: STRING
		do
			across String_8_scope as scope loop
				format_upper := scope.item
				format_upper.append (format); format_upper.to_upper
				zone_index := format_upper.substring_index (Time_zone_designator, 1)
				if zone_index.to_boolean then
					if format_upper.substring_index (Time_zone_designator, zone_index + 3).to_boolean then
						Result := 2
					else
						Result := 1
					end
				end
			end
		ensure
			valid_count: format.as_upper.has_substring (Time_zone_designator) implies Result > 0
		end

	modification_time (file: FILE_PATH): EL_DATE_TIME
		do
			if file.exists then
				create Result.make_from_epoch (file.modification_time)
			else
				create Result.make_from_other (Origin)
			end
		end

feature -- Integer field representations

	Date_representation: EL_DATE_REPRESENTATION
		-- maps reflected `INTEGER' field to `DATE'
		once
			create Result.make (date_default_format_string)
		end

	Representation: EL_DATE_TIME_REPRESENTATION
		-- maps reflected `INTEGER' field to `EL_DATE_TIME'
		once
			create Result.make (Default_format_string)
		end

	Time_representation: EL_TIME_REPRESENTATION
		-- maps reflected `INTEGER' field to `TIME'
		once
			create Result.make (ISO_8601.time_extended)
		end

feature -- Constants

	ISO_8601: TUPLE [time, time_extended, date, date_extended, format, format_extended: STRING]
		local
			s: EL_STRING_8_ROUTINES
		once
			create Result
			Result.time_extended := "[0]hh:[0]mi:[0]ss"
			Result.time := s.pruned (Result.time_extended, ':')
			Result.date_extended := "yyyy-[0]mm-[0]dd"
			Result.date := s.pruned (Result.date_extended, '-')

			Result.format := Result.date + "T" + Result.time + "Z"
			Result.format_extended := Result.date_extended + "T" + Result.time_extended + "Z"
		end

	Origin: DATE_TIME
		local
			dt: DATE_TIME
		once
			create dt.make_from_epoch (0)
			Result := dt.Origin
		end

	Time_zone_designator: STRING = "TZD"

	Zone: TUPLE [gmt, pdt, pst, utc: STRING]
		once
			create Result
			Tuple.fill (Result, "GMT, PDT, PST, UTC")
		end

feature -- Constants

	Zone_table: EL_HASH_TABLE [INTEGER, STRING]
		-- Zones relative to UTC formated as hours and mins
		once
			create Result.make (<<
				[Zone.PST, -8_00],
				[Zone.PDT, -7_00],
				[Zone.GMT, 0],
				[Zone.UTC, 0]
			>>)
		end

end