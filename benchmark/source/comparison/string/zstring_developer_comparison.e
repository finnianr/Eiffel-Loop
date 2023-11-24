note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-24 10:54:47 GMT (Friday 24th November 2023)"
	revision: "16"

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
			string: ZSTRING
		do
			string := Name_manifest

			compare ("perform benchmark", <<
				["first method",	agent first_method (string)],
				["second method", agent second_method (string)]
			>>)
		end

feature {NONE} -- Operations

	second_method (string: ZSTRING)
		local
			str: ZSTRING; i: INTEGER
		do
			from i := 1 until i > 1000 loop
				str := string.twin
--				str.prune_all_v2 ({CHARACTER_32}'ò')
				i := i + 1
			end
		end

	first_method (string: ZSTRING)
		local
			str: ZSTRING; i: INTEGER
		do
			from i := 1 until i > 1000 loop
				str := string.twin
				str.prune_all ({CHARACTER_32}'ò')
				i := i + 1
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

	]"

end