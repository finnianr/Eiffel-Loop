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
			
			Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss tzd (tzd)
			
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-15 12:42:48 GMT (Saturday 15th May 2021)"
	revision: "10"

class
	PP_DATE_TIME

inherit
	EL_DATE_TIME
		redefine
			make, date_time_valid, default_format_string
		end

	EL_SHARED_DATE_TIME

create
	make, make_now

feature {EL_DATE_TEXT} -- Initialization

	make (str: STRING)
		-- formats
		-- 	Long: "Wed Dec 20 2017 09:10:46 GMT+0000 (GMT)"
		-- 	Short "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy tzd"
		do
			format_i := format_index (str)
			Precursor (str)
		end

feature -- Access

	default_format_string: STRING
			-- Default output format string
		do
			if format_i.to_boolean then
				Result := Format_options [format_i]
			else
				create Result.make_empty
			end
		end

feature -- Contract support

	date_time_valid (s: STRING; format: STRING): BOOLEAN
		do
			Result := Precursor (s, Format_options [format_index (s)])
		end

feature {NONE} -- Implementation

	format_index (s: STRING): INTEGER
		local
			week_day: STRING
		do
			if s.has ('(') and then s.has (')') then
				week_day := s.substring (1, 3)
				week_day.to_upper
				if Date_time.Days_text.has (week_day) then
					Result := 3
				else
					Result := 2
				end
			else
				Result := 1
			end
		end

feature {NONE} -- Internal attributes

	format_i: INTEGER

feature {NONE} -- Constants

	Format_options: ARRAY [STRING]
		local
			format: STRING
		once
			format := "Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss tzd (tzd)"
			Result := <<
				"[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy tzd", format, "Ddd " + format
			>>
		end

end