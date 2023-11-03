note
	description: "Compactable date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-03 9:04:10 GMT (Friday 3rd November 2023)"
	revision: "5"

class
	COMPACTABLE_DATE

inherit
	EL_COMPACTABLE_REFLECTIVE
		rename
			compact_integer_32 as compact_date,
			make_from_integer_32 as make_from_compact_date,
			set_from_integer_32 as set_from_compact_date
		end

create
	make, make_from_compact_date

feature {NONE} -- Initialization

	make (a_year, a_month, a_day: INTEGER)
		do
			year := a_year; month := a_month; day := a_day
		end

feature -- Access

	day: INTEGER
			-- Day of the current object

	month: INTEGER
			-- Month of the current object

	year: INTEGER
			-- Year of the current object

feature {NONE} -- Constants

	Field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		once
			create Result.make (Current, "[
				day := 1 .. 8
				month := 9 .. 16
				year := 17 .. 32
			]")
		end

end