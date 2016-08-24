note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-21 12:08:45 GMT (Sunday 21st August 2016)"
	revision: "2"

class
	EL_LOCALE_DATE_TEXT

inherit
	EL_ENGLISH_DATE_TEXT
		redefine
			week_day_name, month_name, ordinal_indicator, Default_ordinal_indicator
		end

	EL_MODULE_LOCALE

create
	make
	
feature {NONE} -- Implementation

	week_day_name (day: INTEGER; short: BOOLEAN): ZSTRING
			--	
		do
			Result := Locale * Precursor (day, short)
		end

	month_name (month_of_year: INTEGER; short: BOOLEAN): ZSTRING
			--
		do
			if not short and then month_of_year = 5 then
				Result := Locale * "{May}"
			else
				Result := Locale * Precursor (month_of_year, short)
			end
		end

feature {NONE} -- Implementation

	ordinal_indicator (i: INTEGER): ZSTRING
			--	
		do
			Result := Locale * Ordinal_indicator_template #$ [i]
		end

feature {NONE} -- Constants

	Default_ordinal_indicator: ZSTRING
			--	
		once
			Result := ordinal_indicator (0)
		end

	Ordinal_indicator_template: ZSTRING
		once
			Result := "{ordinal-indicator.%S}"
		end

end
