note
	description: "Compactable date using field ranges to define compaction"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 10:59:27 GMT (Saturday 19th April 2025)"
	revision: "3"

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
			create Result.make (field_list)
			Result.set_32 (field ($day), 1, 31)
			Result.set_32 (field ($month), 1, 12)
			Result.set_64 (field ($year), -100_000, 100_000)
			Result.initialize
		end

end