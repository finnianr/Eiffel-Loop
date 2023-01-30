note
	description: "[
		Cached VS uncached calculation of shift count for bit_mask in descendants of [EL_NUMERIC_BIT_ROUTINES]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-30 17:55:29 GMT (Monday 30th January 2023)"
	revision: "1"

class
	CACHED_VS_UNCACHED_SHIFT_COUNT

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Cached VS uncached bit routine shift_count"

feature -- Basic operations

	execute
		do
			compare ("Compare caching of shift_count for mask", <<
				["Cached NATURAL",	agent do_uncached],
				["Uncached INTEGER",	agent do_cached]
			>>)
		end

feature {NONE} -- Implementation

	do_cached
		local
			i, j: INTEGER; integer: EL_INTEGER_32_BIT_ROUTINES
			mask, value: INTEGER
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := integer.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

	do_uncached
		local
			i: INTEGER; natural: NATURAL_32_BIT_ROUTINES
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := natural.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

end