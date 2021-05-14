note
	description: "[
		Object representing Paypal payment transaction time. It assumes the following format and is converted to UTC.
		
			HH:MM:SS Mmm DD, YYYY PST
			
		Used in `{[$source PP_TRANSACTION]}.payment_date'
	]"
	notes: "[
		In the Paypal NVP manual it says `PDT' for the timezone, but this is incorrect.
		The guys at support@paypal-techsupport.com say it should `PST'.
		
		Because the online IPN listener test uses a different format in a prepopulated field, this is
		accommodated as well. 
			
			Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 20:08:38 GMT (Thursday 13th May 2021)"
	revision: "9"

class
	PP_DATE_TIME

inherit
	EL_DATE_TIME
		redefine
			make, date_time_valid, default_format_string
		end

	EL_STRING_8_CONSTANTS

create
	make, make_now

feature {EL_DATE_TEXT} -- Initialization

	make (str: STRING)
		-- use either GMT format or PDT
		local
			l_zone: STRING
		do
			l_zone := time_zone (str)
			if UTC_adjust.has (l_zone) then
				if l_zone ~ Zone_gmt then
					make_from_gmt (str)
				else
					make_from_zone (str, l_zone)
				end
			else
				make_now
			end
		end

	make_from_gmt (str: STRING)
		-- make from example: "Wed Dec 20 2017 09:10:46 GMT+0000 (GMT)"
		require
			has_6_spaces: str.occurrences (' ') = 6
			gmt_zone: str.has_substring (Zone_gmt)
			has_2_colons: str.occurrences (':') = 2
		do
			make_from_zone_and_format (str, Zone_gmt, Format_date_time, 5)
			-- 5 means ignore "Wed "
		end

	make_from_zone (str, a_zone: STRING)
		-- make from example "19:35:01 Apr 09, 2016 PST+1"
		require
			has_3_spaces: str.occurrences (' ') = 4
			has_1_comma: str.occurrences (',') = 1
			has_2_colons: str.occurrences (':') = 2
		do
			make_utc_from_zone_and_format (str, a_zone, Format_time_date, 1, UTC_adjust [a_zone])
		end

feature -- Access

	default_format_string: STRING
			-- Default output format string
		do
			Result := Format_time_date
		end

feature -- Contract support

	date_time_valid (s: STRING; a_format: STRING): BOOLEAN
		do
			-- 03:22:41 Apr 10, 2018 PDT
			Result := True
--			if a_format = Format_time_date then
--				if s [3] = ':' then
--					Result := Precursor (s.substring (1, 21), Format_time_date)
--				end
--			end
		end

feature {NONE} -- Implementation

	time_zone (str: STRING): STRING
		local
			spaces: EL_OCCURRENCE_INTERVALS [STRING]; s: EL_STRING_8_ROUTINES
		do
			create spaces.make (str, s.character_string (' '))
			inspect spaces.count
				when 4 then
					Result := str.substring (spaces.last_upper + 1, spaces.last_upper + 3)
				when 6 then
					spaces.go_i_th (5)
					Result := str.substring (spaces.item_upper + 1, spaces.item_upper + 3)
			else
				Result := Empty_string_8
			end
		end

feature -- Constants

	UTC_adjust: EL_HASH_TABLE [INTEGER, STRING]
		-- Zone adjustments to UTC
		once
			create Result.make (<<
				[Zone_gmt, 0], ["PDT", 7], ["PST", 8]
			>>)
		end

	Zone_gmt: STRING = "GMT"

feature {NONE} -- Constants

	Format_date_time: STRING = "mmm [0]dd yyyy [0]hh:[0]mi:[0]ss"

	Format_time_date: STRING = "[0]hh:[0]mi:[0]ss mmm [0]dd, yyyy"

end