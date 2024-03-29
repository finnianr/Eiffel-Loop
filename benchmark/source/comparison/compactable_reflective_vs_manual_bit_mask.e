note
	description: "[
		Compare using ${EL_COMPACTABLE_REFLECTIVE} to automate object data compaction to numeric types
		vs traditional manual method.
	]"
	notes: "[
		Passes over 1000 millisecs (in descending order)

			Manual compaction    :  6318.0 times (100%)
			Automated compaction :  2388.0 times (-62.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "4"

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