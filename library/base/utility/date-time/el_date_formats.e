note
	description: "Summary description for {EL_DATE_FORMATS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_DATE_FORMATS

feature -- Format strings

	dd_mmm_yyyy: STRING = "$numeric_day $short_month_name $year"

	canonical: STRING = "$long_day_name $canonical_numeric_month $long_month_name $year"

	short_canonical: STRING = "$short_day_name $canonical_numeric_month $short_month_name $year"

end
