note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 17:36:19 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_LOCALE_DATE_ROUTINES

inherit
	EL_DATE_ROUTINES

	EL_MODULE_LOCALE

feature {NONE} -- Implementation

	short_month (month: INTEGER): EL_ASTRING
			--	
		do
			Result := Locale * months_text [month]
		end

	day_full_text (day_of_week: INTEGER): EL_ASTRING
			--
		do
			Result := Locale * long_days_text [day_of_week]
		end

	month_full_text (month: INTEGER): EL_ASTRING
			--
		do
			Result := Locale * long_months_text [month]
		end

feature {NONE} -- Implementation

	ordinal_indicator (i: INTEGER): EL_ASTRING
			--	
		do
			Result := Locale * (Ordinal_indicator_template.substituted (<< i >>))
		end

feature {NONE} -- Constants

	Default_ordinal_indicator: EL_ASTRING
			--	
		once
			Result := ordinal_indicator (0)
		end

	Ordinal_indicator_template: EL_TEMPLATE_STRING
		once
			Result := "{ordinal-indicator.$S}"
		end

end
