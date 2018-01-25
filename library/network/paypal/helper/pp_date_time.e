note
	description: "[
		Object representing Paypal payment transaction time. It assumes the following format and is converted to UTC.
		
			HH:MM:SS Mmm DD, YYYY PST
			
		Used in `PP_TRANSACTION.payment_date'
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
	date: "2018-01-22 16:51:58 GMT (Monday 22nd January 2018)"
	revision: "3"

class
	PP_DATE_TIME

inherit
	EL_DATE_TIME
		redefine
			make
		end

create
	make, make_now

feature {EL_DATE_TEXT} -- Initialization

	make (s: STRING)
		-- use either GMT format or PDT
		do
			if s.has_substring (Zone.PST) and s.occurrences (',') = 1 then
				make_from_pst (s)
			elseif s.has_substring (Zone.GMT) and s.occurrences (' ') = 6 then
				make_from_gmt (s)
			else
				Precursor (s)
			end
		end

	make_from_gmt (s: STRING)
		-- make from example: "Wed Dec 20 2017 09:10:46 GMT+0000 (GMT)"
		require
			has_6_spaces: s.occurrences (' ') = 6
			gmt_zone: s.has_substring (Zone.GMT)
			has_2_colons: s.occurrences (':') = 2
		do
			make_from_zone_and_format (s, Zone.GMT, Format.date_time, 5)
		end

	make_from_pst (s: STRING)
		-- make from example "19:35:01 Apr 09, 2016 PST+1"
		require
			has_3_spaces: s.occurrences (' ') = 4
			has_1_comma: s.occurrences (',') = 1
			has_2_colons: s.occurrences (':') = 2
		do
			make_from_zone_and_format (s, Zone.PST, Format.time_date, 1)
			hour_add (8)
		end

feature -- Constants

	Zone: TUPLE [PST, GMT: STRING]
		once
			Result := ["PST", "GMT"]
		end

feature {NONE} -- Constants

	Format: TUPLE [time_date, date_time: STRING]
		once
			Result := ["[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy", "Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss"]
		end
end
