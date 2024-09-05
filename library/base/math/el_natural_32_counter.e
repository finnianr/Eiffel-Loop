note
	description: "[
		A ${NATURAL_32_REF} for counting increments of 1 and with a zero-padding convenience function
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-05 7:39:42 GMT (Thursday 5th September 2024)"
	revision: "5"

class
	EL_NATURAL_32_COUNTER

inherit
	NATURAL_32_REF
		export
			{NONE} all
			{ANY} item, set_item
		end

feature -- Element change

	bump
		do
			set_item (item + 1)
		end

	reset
		do
			set_item (0)
		end

feature -- Access

	zero_padded (digit_count: INTEGER): STRING
		local
			math: EL_INTEGER_MATH
		do
			create Result.make_filled ('0', digit_count)
			Result.remove_tail (math.digit_count (digit_count).min (Result.count))
			Result.append_natural_32 (item)
		end

end