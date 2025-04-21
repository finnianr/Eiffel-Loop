note
	description: "Date formats accessible via of ${EL_SHARED_DATE_FORMAT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:38:32 GMT (Monday 21st April 2025)"
	revision: "14"

class
	EL_DATE_FORMATS

inherit
	ANY

	EL_MODULE_ITERABLE; EL_MODULE_TUPLE

feature -- Constants

	All_formats: ARRAY [STRING]
		once
			Result := << Canonical, DD_MMM_YYYY, Short_canonical, YYYY_MMM_DD, YYYY_MMM_DD_th >>
		end

	Var: TUPLE [
		canonical_numeric_day, long_day_name, long_month_name, numeric_day, numeric_month,
		short_day_name, short_month_name, short_year, year: IMMUTABLE_STRING_8
	]
		-- Template variable names
		once
			create Result
			Tuple.fill_immutable (Result,
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

feature -- Factory

	new_format (parts: ARRAY [IMMUTABLE_STRING_8]): STRING
		do
			create Result.make (Iterable.character_count (parts, 2) + 1)

			across parts as p loop
				if p.cursor_index > 1 then
					Result.append_character (' ')
				end
				Result.append_character ('$')
				Result.append (p.item)
			end
		end
end