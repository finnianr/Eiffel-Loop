note
	description: "Localized date text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 7:34:34 GMT (Wednesday 19th May 2021)"
	revision: "4"

class
	EL_LOCALE_DATE_TEXT

inherit
	EL_ENGLISH_DATE_TEXT
		rename
			make as make_default
		redefine
			week_day_name, month_name, ordinal_indicator, Default_ordinal_indicator
		end

create
	make

feature {NONE} -- Initialization

	make (a_locale: like locale)
		do
			locale := a_locale
			make_default
		end

feature {NONE} -- Implementation

	month_name (month_of_year: INTEGER; short: BOOLEAN): ZSTRING
			--
		do
			if not short and then month_of_year = 5 then
				locale.set_next_translation ("May")
				Result := locale * "{May}"
			else
				Result := locale * Precursor (month_of_year, short)
			end
		end

	week_day_name (day: INTEGER; short: BOOLEAN): ZSTRING
			--	
		do
			Result := locale * Precursor (day, short)
		end

feature {NONE} -- Implementation

	ordinal_indicator (i: INTEGER): ZSTRING
			--	
		do
			locale.set_next_translation (Precursor (i))
			Result := locale * Ordinal_indicator_template #$ [i]
		end

feature {NONE} -- Internal attributes

	locale: EL_DEFERRED_LOCALE_I

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