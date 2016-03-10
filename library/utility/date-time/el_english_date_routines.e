note
	description: "Summary description for {EL_ENGLISH_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-21 13:08:38 GMT (Thursday 21st March 2013)"
	revision: "2"

class
	EL_ENGLISH_DATE_ROUTINES

inherit
	EL_DATE_ROUTINES

feature {NONE} -- Implementation

	Default_ordinal_indicator: EL_ASTRING
			--	
		once
			Result := "th"
		end

	ordinal_indicator (i: INTEGER): EL_ASTRING
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

	short_month (month: INTEGER): EL_ASTRING
			--	
		once
			Result := months_text [month]
			Result.to_proper_case
		end

	day_full_text (day_of_week: INTEGER): EL_ASTRING
			--
		do
			Result := long_days_text [day_of_week]
			Result.to_proper_case
		end

	month_full_text (month: INTEGER): EL_ASTRING
			--
		do
			Result := long_months_text [month]
			Result.to_proper_case
		end

end
