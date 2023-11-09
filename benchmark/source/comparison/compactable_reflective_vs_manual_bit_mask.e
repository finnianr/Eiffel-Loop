note
	description: "[
		Compare using [$source EL_COMPACTABLE_REFLECTIVE] to automate object data compaction to numeric types
		vs traditional manual method.
	]"
	notes: "[
		Passes over 1000 millisecs (in descending order)

		Manual compaction    :  6187.0 times (100%)
		Automated compaction :  1535.0 times (-75.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 11:56:28 GMT (Thursday 9th November 2023)"
	revision: "2"

class
	COMPACTABLE_REFLECTIVE_VS_MANUAL_BIT_MASK

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_REFLECTION_HANDLER

create
	make

feature -- Access

	Description: STRING = "Automated vs manual object data compaction to NATURAL_64"

feature -- Basic operations

	execute
		local
		do
			compare ("Iterating round trip compaction using DATE example", <<
				["Automated compaction", agent automated_date_compaction],
				["Manual compaction",	 agent manual_date_compaction]
			>>)
		end

feature {NONE} -- Implementation

	automated_date_compaction
		local
			date: COMPACTABLE_DATE; i, y, m, d: INTEGER
			compact_date: INTEGER
		do
			y := 2023; m := 10; d := 25
			from i := 1 until i > 1000 loop
				create date.make (y, m, d)
				compact_date := date.compact_date
				create date.make_from_compact_date (compact_date)
				if date.day /= d or date.month /= m or date.year /= y then
					lio.put_line ("Conversion failed")
					i := 10_000
				else
					i := i + 1
				end
			end
		end

	manual_date_compaction
		local
			date: DATE; i, y, m, d: INTEGER
			compact_date: INTEGER
		do
			y := 2023; m := 10; d := 25
			from i := 1 until i > 1000 loop
				create date.make (y, m, d)
				compact_date := date.ordered_compact_date
				create date.make_by_ordered_compact_date (compact_date)
				if date.day /= d or date.month /= m or date.year /= y then
					lio.put_line ("Conversion failed")
					i := 10_000
				else
					i := i + 1
				end
			end
		end

end