note
	description: "Extension to [$source DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 13:21:58 GMT (Monday 17th May 2021)"
	revision: "5"

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

	Zone_gmt: STRING = "GMT"

feature -- Constants

	Zone_table: EL_HASH_TABLE [INTEGER, STRING]
		-- Zones relative to UTC formated as hours and mins
		once
			create Result.make (<<
				["PST", -8_00],
				["PDT", -7_00],
				[Zone_gmt, 0],
				["UTC", 0]
			>>)
		end

end