note
	description: "Summary description for {EL_DATE_FORMATS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DATE_FORMATS

feature -- Format strings

	dd_mmm_yyyy: STRING = "$numeric_day $short_month_name $year"

	canonical: STRING = "$long_day_name $canonical_numeric_month $long_month_name $year"

	short_canonical: STRING = "$short_day_name $canonical_numeric_month $short_month_name $year"

end
