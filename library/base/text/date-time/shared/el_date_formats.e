note
	description: "Date formats accessible via of ${EL_SHARED_DATE_FORMAT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	EL_DATE_FORMATS

inherit
	ANY

	EL_MODULE_TUPLE

feature -- Constants

	All_formats: ARRAY [STRING]
		once
			Result := << Canonical, DD_MMM_YYYY, Short_canonical, YYYY_MMM_DD, YYYY_MMM_DD_th >>
		end

	Var: TUPLE [
		canonical_numeric_day, long_day_name, long_month_name, numeric_day, numeric_month,
		short_day_name, short_month_name, short_year, year: STRING
	]
		-- Template variable names
		once
			create Result
			Tuple.fill (Result,
				"canonical_numeric_day, long_day_name, long_month_name, numeric_day, numeric_month,%
				%short_day_name, short_month_name, short_year, year"
			)
		end

feature -- Format strings

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
			create Result.make (s.character_count (parts, 2) + 1)

			across parts as p loop
				if p.cursor_index > 1 then
					Result.append_character (' ')
				end
				Result.append_character ('$')
				Result.append (p.item)
			end
		end
end