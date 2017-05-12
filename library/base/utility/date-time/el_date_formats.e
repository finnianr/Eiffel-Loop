note
	description: "Summary description for {EL_DATE_FORMATS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-27 11:57:21 GMT (Thursday 27th April 2017)"
	revision: "2"

class
	EL_DATE_FORMATS

feature -- Format strings

	Date_formats: ARRAY [STRING]
		once
			Result := << dd_mmm_yyyy, canonical, short_canonical >>
		end

	dd_mmm_yyyy: STRING = "$numeric_day $short_month_name $year"

	canonical: STRING = "$long_day_name $canonical_numeric_month $long_month_name $year"

	short_canonical: STRING = "$short_day_name $canonical_numeric_month $short_month_name $year"

end
