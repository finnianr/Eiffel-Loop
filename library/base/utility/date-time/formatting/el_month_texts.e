note
	description: "Deferred i18n of month words"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-28 12:10:09 GMT (Thursday 28th October 2021)"
	revision: "1"

class
	EL_MONTH_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			initialize_fields
		end

create
	make_with_locale

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			full_names := <<
				january, february, march, april, may, june, july,
				august, september, october, november, december
			>>
			short_names := <<
				jan, feb, mar, apr, may_short, jun, jul, aug, sep, oct, nov, dec
			>>
			full_names.compare_objects
			short_names.compare_objects

			create ordinal_indicator.make_empty (4)
			across << ordinal_default, ordinal_first, ordinal_second, ordinal_third >> as suffix loop
				ordinal_indicator.extend (suffix.item)
			end
		end

feature -- Access

	full_names: ARRAY [ZSTRING]

	short_names: ARRAY [ZSTRING]

	ordinal_indicator: SPECIAL [ZSTRING] note option: transient attribute end

feature -- Months of year

	january: ZSTRING

	february: ZSTRING

	march: ZSTRING

	april: ZSTRING

	may: ZSTRING

	june: ZSTRING

	july: ZSTRING

	august: ZSTRING

	september: ZSTRING

	october: ZSTRING

	november: ZSTRING

	december: ZSTRING

feature -- Short months of year

	jan: ZSTRING

	feb: ZSTRING

	mar: ZSTRING

	apr: ZSTRING

	may_short: ZSTRING

	jun: ZSTRING

	jul: ZSTRING

	aug: ZSTRING

	sep: ZSTRING

	oct: ZSTRING

	nov: ZSTRING

	dec: ZSTRING

feature -- Ordinal indicators

	ordinal_default: ZSTRING

	ordinal_first: ZSTRING

	ordinal_second: ZSTRING

	ordinal_third: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING_8
			-- description of attributes
		do
			Result := "[
				may_short:
					May
				ordinal_default:
					th
				ordinal_first:
					st
				ordinal_second:
					nd
				ordinal_third:
					rd
			]"
		end
end