note
	description: "Compactable date using field ranges to define compaction"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-13 17:22:39 GMT (Sunday 13th October 2024)"
	revision: "1"

class
	RANGE_COMPACTABLE_DATE

inherit
	COMPACTABLE_DATE
		redefine
			Range_table
		end

create
	make, make_from_compact_date

feature {NONE} -- Constants

	Range_table: EL_ATTRIBUTE_RANGE_TABLE
		once
			create Result
			Result [$day] := 1 |..| 31
			Result [$month] := 1 |..| 12
			Result [$year] := -100_000 |..| 100_000
			
			Result.initialize (Current)
		end

end