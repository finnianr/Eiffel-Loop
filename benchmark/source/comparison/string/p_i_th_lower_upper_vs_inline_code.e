note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "14"

class
	P_I_TH_LOWER_UPPER_VS_INLINE_CODE

inherit
	EL_BENCHMARK_COMPARISON
		redefine
			initialize
		end

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	initialize
		local
			split_list: EL_SPLIT_STRING_32_LIST
		do
			create split_list.make_adjusted (Name_manifest, ',', {EL_SIDE}.Left)
			area := split_list.to_intervals.area
		end

feature -- Access

	Description: STRING = "Compare call to i_th_lower_upper with inline code"

feature -- Basic operations

	execute
		do
			compare ("Calculate compact INTERVAL_64", <<
				["Test i_th_lower_upper", agent test_i_th_lower_upper],
				["Test inline code",		  agent test_inline_code]
			>>)
		end

feature {NONE} -- Implemenatation

	test_i_th_lower_upper
		local
			i, n, lower, upper: INTEGER; ir: EL_INTERVAL_ROUTINES; p: EL_POINTER_ROUTINES
			compact: INTEGER_64
		do
			n := area.count
			from i := 1 until i > n loop
				lower := p.i_th_lower_upper (area, i, $upper)
				compact := ir.compact (lower, upper)
				i := i + 1
			end
		end

	test_inline_code
		local
			i, j, n: INTEGER; ir: EL_INTERVAL_ROUTINES
			compact: INTEGER_64
		do
			n := area.count
			from i := 1 until i > n loop
				j := (i - 1) * 2
				if attached area as a then
					compact := ir.compact (a [j], a [j + 1])
				end
				i := i + 1
			end
		end

feature {NONE} -- Initialization

	area: SPECIAL [INTEGER]
end