note
	description: "Deferred i18n of day of week words"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-28 12:10:22 GMT (Thursday 28th October 2021)"
	revision: "1"

class
	EL_DAY_OF_WEEK_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		rename
			english_table as Empty_table
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
				sunday, monday, tuesday, wednesday, thursday, friday, saturday
			>>
			short_names := << sun, mon, tue, wed, thu, fri, sat >>

			full_names.compare_objects
			short_names.compare_objects
		end

feature -- Access

	full_names: ARRAY [ZSTRING]

	short_names: ARRAY [ZSTRING]

feature -- Days of week

	friday: ZSTRING

	monday: ZSTRING

	saturday: ZSTRING

	sunday: ZSTRING

	thursday: ZSTRING

	tuesday: ZSTRING

	wednesday: ZSTRING

feature -- Short days of week

	fri: ZSTRING

	mon: ZSTRING

	sat: ZSTRING

	sun: ZSTRING

	thu: ZSTRING

	tue: ZSTRING

	wed: ZSTRING
end