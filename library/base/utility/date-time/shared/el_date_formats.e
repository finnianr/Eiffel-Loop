note
	description: "Date formats accessible via of [$source EL_SHARED_DATE_FORMAT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-09 13:11:16 GMT (Friday 9th June 2023)"
	revision: "8"

class
	EL_DATE_FORMATS

inherit
	ANY

	EL_MODULE_TUPLE

feature -- Format strings

	All_formats: ARRAY [STRING]
		once
			Result := << Canonical, DD_MMM_YYYY, Short_canonical, YYYY_MMM_DD, YYYY_MMM_DD_th >>
		end

	Var: TUPLE [
		canonical_numeric_day, long_day_name, long_month_name, numeric_day, numeric_month,
		short_day_name, short_month_name, short_year, year: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"canonical_numeric_day, long_day_name, long_month_name, numeric_day, numeric_month,%
				%short_day_name, short_month_name, short_year, year"
			)
		end

	Canonical: STRING
		once
			Result := new_format (<<
				Var.long_day_name, Var.canonical_numeric_day, Var.long_month_name, Var.year
			>>)
		end

	DD_MMM_YYYY: STRING
		once
			Result := new_format (<< Var.numeric_day, Var.short_month_name, Var.year >>)
		end

	Short_canonical: STRING
		once
			Result := new_format (<<
				Var.short_day_name, Var.canonical_numeric_day, Var.short_month_name, Var.year
			>>)
		end

	YYYY_MMM_DD: STRING
		once
			Result := new_format (<< Var.year, Var.short_month_name, Var.numeric_day >>)
		end

	YYYY_MMM_DD_th: STRING
		once
			Result := new_format (<< Var.year, Var.short_month_name, Var.canonical_numeric_day >>)
		end

feature {NONE} -- Implementation

	new_format (parts: ARRAY [STRING]): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.character_string ('$') + s.joined_with (parts, Space_dollor)
		end

feature {NONE} -- Constants

	Space_dollor: STRING = " $"
end