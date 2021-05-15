note
	description: "Extension to [$source DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-15 10:42:53 GMT (Saturday 15th May 2021)"
	revision: "3"

class
	EL_DATE_TIME_TOOLS

inherit
	DATE_TIME_TOOLS

feature -- Access

	leading_string_count (s: STRING; space_count: INTEGER): INTEGER
		-- count of leading characters up to `space_count' number of spaces counting from end
		local
			i, count: INTEGER; c: CHARACTER
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

	Format_hh_mi_ss: STRING = "[0]hh:[0]mi:[0]ss"

	Format_iso_8601: STRING = "yyyy-[0]mm-[0]ddT[0]hh:[0]mi:[0]ssZ"

	Format_iso_8601_short: STRING = "yyyy[0]mm[0]ddT[0]hh[0]mi[0]ssZ"

	Zone_gmt: STRING = "GMT"

feature -- Constants

	Zone_table: EL_HASH_TABLE [INTEGER, STRING]
		-- Zone relative to UTC
		once
			create Result.make (<<
				["PST", -8_00],
				["PDT", -7_00],
				[Zone_gmt, 0],
				["UTC", 0]
			>>)
		end

end