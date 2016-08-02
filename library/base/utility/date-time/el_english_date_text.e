note
	description: "Summary description for {EL_ENGLISH_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:06:45 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_ENGLISH_DATE_TEXT

inherit
	EL_DATE_TEXT

feature {NONE} -- Implementation

	Default_ordinal_indicator: ZSTRING
			--	
		once
			Result := "th"
		end

	ordinal_indicator (i: INTEGER): ZSTRING
		do
			inspect i
				when 1 then
					Result := "st"
				when 2 then
					Result := "nd"
				when 3 then
					Result := "rd"
			else
				Result := Default_ordinal_indicator
			end
		end

	week_day_name (day_of_week: INTEGER; short: BOOLEAN): ZSTRING
			--
		do
			if short then
				Result := days_text [day_of_week]
			else
				Result := long_days_text [day_of_week]
			end
			Result.to_proper_case
		end

	month_name (month_of_year: INTEGER; short: BOOLEAN): ZSTRING
			--
		do
			if short then
				Result := months_text [month_of_year]
			else
				Result := long_months_text [month_of_year]
			end
			Result.to_proper_case
		end

end