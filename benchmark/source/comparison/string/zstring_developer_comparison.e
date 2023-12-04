note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-04 10:17:35 GMT (Monday 4th December 2023)"
	revision: "19"

class
	ZSTRING_DEVELOPER_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "{ZSTRING} development methods"

feature -- Basic operations

	execute
		local
			str: ZSTRING
		do
			str := Name_manifest

			compare ("perform benchmark", <<
				["method 1", agent do_method (str.area, str.unencoded_area, 1, str.count)],
				["method 2", agent do_method (str.area, str.unencoded_area, 2, str.count)],
				["method 3", agent do_method (str.area, str.unencoded_area, 3, str.count)],
				["method 4", agent do_method (str.area, str.unencoded_area, 4, str.count)],
				["method 5", agent do_method (str.area, str.unencoded_area, 5, str.count)]
			>>)
		end

feature {NONE} -- Operations

	do_method (area: SPECIAL [CHARACTER]; area_32: SPECIAL [CHARACTER_32]; id, count: INTEGER)
		local
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; block_index, i: INTEGER
			uc: CHARACTER_32; c_i: CHARACTER; z_code: NATURAL
		do
			across 1 |..| 1000 as n loop
				block_index := 0
				from until i = count loop
					inspect area [i]
						when Substitute then
							uc := iter.item ($block_index, area_32, i + 1)
							inspect id
								when 1 then
								when 2 then
								when 3 then
								when 4 then
								when 5 then
							end
					else
					end
					i := i + 1
				end
			end
		end

note
	notes: "[
		**24 Nov 2023**
		
		**to_string_32_v2** uses technique:

			when Substitute then
				interval_count := unencoded_interval_count (area_32, j_lower)
				area_out.copy_data (area_32, j_lower, old_count + i, interval_count)
				j_lower := j_lower + interval_count + 2
				i := i + interval_count

		Passes over 500 millisecs (in descending order)

			to_string_32  : 164.0 times (100%)
			to_string_32_v2 :  95.0 times (-42.1%)
			
		**prune_all_v2** use technique:

			when Substitute then
				interval_count := unencoded_interval_count (uc_area, k_lower)
				k_upper := k_lower + interval_count - 1
			
		Passes over 500 millisecs (in descending order)

			prune_all    :  38.0 times (100%)
			prune_all_v2 :  38.0 times (-0.0%)
			
		**when 0 .. C then VS if x <= C then**

		Passes over 1000 millisecs (in descending order)

			when 0 .. 0x7F then  : 16645498.0 times (100%)
			when 0 .. 0xFF then  : 16610377.0 times (-0.2%)
			if code <= 0x7F then : 16558972.0 times (-0.5%)
			if code <= 0xFF then : 13450191.0 times (-19.2%)

	]"

end