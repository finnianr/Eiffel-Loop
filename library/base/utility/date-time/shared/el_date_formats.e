note
	description: "Date formats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-08 10:48:27 GMT (Thursday 8th June 2023)"
	revision: "7"

class
	EL_DATE_FORMATS

feature -- Format strings

	Date_formats: ARRAY [STRING]
		once
			Result := << dd_mmm_yyyy, canonical, short_canonical, yyyy_mmm_dd >>
		end

	canonical: STRING = "$long_day_name $canonical_numeric_month $long_month_name $year"

	dd_mmm_yyyy: STRING = "$numeric_day $short_month_name $year"

	short_canonical: STRING = "$short_day_name $canonical_numeric_month $short_month_name $year"

	yyyy_mmm_dd: STRING = "$year $short_month_name $numeric_day"

end