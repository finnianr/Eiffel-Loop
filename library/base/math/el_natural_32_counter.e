note
	description: "[
		A ${NATURAL_32_REF} for counting increments of 1 and with a zero-padding convenience function
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-28 15:27:37 GMT (Friday 28th February 2025)"
	revision: "6"

class
	EL_NATURAL_32_COUNTER

inherit
	NATURAL_32_REF
		export
			{NONE} all
			{ANY} item, set_item, to_integer_32
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