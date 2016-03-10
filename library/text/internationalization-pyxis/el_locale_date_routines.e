note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOCALE_DATE_ROUTINES

inherit
	EL_DATE_ROUTINES

	EL_MODULE_LOCALE

feature {NONE} -- Implementation
	
	short_month (month: INTEGER): STRING
			--	
		do
			Result := locale.translation (months_text [month])
		end

	day_full_text (day_of_week: INTEGER): STRING
			--
		do
			Result := locale.translation (long_days_text [day_of_week])
		end

	month_full_text (month: INTEGER): STRING
			--
		do
			Result := locale.translation (long_months_text [month])
		end

feature {NONE} -- Constants

	Ordinal_indicator_default: STRING
			--	
		once
			Result := locale.translation (Ordinal_indicator_id)
		end

	Ordinal_indicator_1: STRING
			--	
		once
			Result := locale.translation (Ordinal_indicator_id + ".1")
		end

	Ordinal_indicator_2: STRING
			--	
		once
			Result := locale.translation (Ordinal_indicator_id + ".2")
		end

	Ordinal_indicator_3: STRING
			--	
		once
			Result := locale.translation (Ordinal_indicator_id + ".3")
		end

	Ordinal_indicator_id: STRING = "ordinal-indicator"

end
