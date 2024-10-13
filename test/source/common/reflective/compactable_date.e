note
	description: "Compactable date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-13 8:33:57 GMT (Sunday 13th October 2024)"
	revision: "6"

class
	COMPACTABLE_DATE

inherit
	EL_COMPACTABLE_REFLECTIVE
		rename
			compact_integer_32 as compact_date,
			make_from_integer_32 as make_from_compact_date,
			set_from_integer_32 as set_from_compact_date
		redefine
			Range_table
		end

create
	make, make_from_compact_date

feature {NONE} -- Initialization

	make (a_year: INTEGER_16; a_month, a_day: NATURAL_8)
		do
			year := a_year; month := a_month; day := a_day
		end

feature -- Access

	day: NATURAL_8
		-- Day of the current object

	month: NATURAL_8
		-- Month of the current object

	year: INTEGER_16
			-- Year of the current object

feature {NONE} -- Constants

	Range_table: EL_ATTRIBUTE_BIT_RANGE_TABLE
		once
			create Result.make (Current, "[
				day := 1 .. 8
				month := 9 .. 16
				year := 17 .. 32
			]")
		end

end