note
	description: "Extension to [$source DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 8:30:57 GMT (Wednesday 19th May 2021)"
	revision: "6"

class
	EL_DATE_TIME_TOOLS

inherit
	DATE_TIME_TOOLS

	EL_MODULE_TUPLE

feature -- Access

	leading_string_count (s: STRING; space_count: INTEGER): INTEGER
		-- count of leading characters up to `space_count' number of spaces counting from end
		local
			i, count: INTEGER
		do
			from i := s.count until count = space_count or else i = 0 loop
				if s [i].is_space then
					count := count + 1
				end
				i := i - 1
			end
			Result := i
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