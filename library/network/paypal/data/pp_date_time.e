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
	date: "2018-10-17 14:37:30 GMT (Wednesday 17th October 2018)"
	revision: "6"

class
	PP_DATE_TIME

inherit
	EL_DATE_TIME
		redefine
			make
		end

	EL_STRING_8_CONSTANTS
		undefine
			is_equal, copy, out
		end

create
	make, make_now

feature {EL_DATE_TEXT} -- Initialization

	make (s: STRING)
		-- use either GMT format or PDT
		local
			spaces: EL_OCCURRENCE_INTERVALS [STRING]; l_zone: STRING
		do
			create spaces.make (s, character_string_8 (' '))
			inspect spaces.count
				when 4 then
					l_zone := s.substring (spaces.last_upper + 1, spaces.last_upper + 3)
				when 6 then
					spaces.go_i_th (5)
					l_zone := s.substring (spaces.item_upper + 1, spaces.item_upper + 3)
			else
				l_zone := Empty_string_8
			end
			if UTC_adjust.has (l_zone) then
				if l_zone ~ Zone_gmt then
					make_from_gmt (s)
				else
					make_from_zone (s, l_zone)
				end
			else
				make_now
			end
		end

	make_from_gmt (s: STRING)
		-- make from example: "Wed Dec 20 2017 09:10:46 GMT+0000 (GMT)"
		require
			has_6_spaces: s.occurrences (' ') = 6
			gmt_zone: s.has_substring (Zone_gmt)
			has_2_colons: s.occurrences (':') = 2
		do
			make_from_zone_and_format (s, Zone_gmt, Format.date_time, 5)
			-- 5 means ignore "Wed "
		end

	make_from_zone (s, a_zone: STRING)
		-- make from example "19:35:01 Apr 09, 2016 PST+1"
		require
			has_3_spaces: s.occurrences (' ') = 4
			has_1_comma: s.occurrences (',') = 1
			has_2_colons: s.occurrences (':') = 2
		do
			make_utc_from_zone_and_format (s, a_zone, Format.time_date, 1, UTC_adjust [a_zone])
		end

feature -- Constants

	Zone_gmt: STRING = "GMT"

	UTC_adjust: EL_HASH_TABLE [INTEGER, STRING]
		-- Zone adjustments to UTC
		once
			create Result.make (<<
				[Zone_gmt, 0], ["PDT", 7], ["PST", 8]
			>>)
		end

feature {NONE} -- Constants

	Format: TUPLE [time_date, date_time: STRING]
		once
			Result := ["[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy", "Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss"]
		end
end
