note
	description: "[
		Object representing Paypal payment transaction time. It assumes the following format and is converted to UTC.
		
			HH:MM:SS Mmm DD, YYYY PST
			
		Used in ${PP_TRANSACTION}.payment_date
	]"
	notes: "[
		In the Paypal NVP manual it says `PDT' for the timezone, but this is incorrect.
		The guys at support@paypal-techsupport.com say it should `PST'.
		
		Because the online IPN listener test uses a different format in a prepopulated field, this is
		accommodated as well. 
			
			Long form: "Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss tzd (tzd)"
			Example: "Wed Dec 20 2017 09:10:46 GMT+0000 (GMT)"
			
			Short form: "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy tzd"
			Example: "Wed Dec 20 2017 09:10:46 UTC"

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 10:32:44 GMT (Thursday 4th April 2024)"
	revision: "21"

class
	PP_DATE_TIME

inherit
	EL_DATE_TIME
		rename
			make as make_from_parts,
			make_from_string as make
		redefine
			make, date_time_valid, default_format_string
		end

	EL_MODULE_DATE_TIME

create
	make, make_default, make_now, make_now_utc

feature {EL_DATE_TEXT} -- Initialization

	make (str: STRING)
		-- formats long or short time zone descriptor. See notes
		do
			make_with_format (str, selected_format (str))
		end

feature -- Contract support

	date_time_valid (s: STRING; format: STRING): BOOLEAN
		do
			Result := Precursor (s, selected_format (s))
		end

feature {NONE} -- Implementation

	selected_format (s: STRING): STRING
		do
			if s.has ('(') and then s.has (')') then
				across String_8_scope as scope loop
					if attached scope.item as week_day then
						week_day.append_substring (s, 1, 3)
						week_day.to_upper
						if Date_time.Days_text.has (week_day) then
							Result := Format_day_long
						else
							Result := Format_long
						end
					end
				end
			else
				Result := Default_format_string
			end
		end

feature -- Constants

	Default_format_string: STRING = "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy tzd"
		-- Default output format string

	Format_long: STRING = "Mmm [0]dd yyyy [0]hh:[0]mi:[0]ss tzd (tzd)"

	Format_day_long: STRING
		once
			Result := "Ddd " + Format_long
		end

end