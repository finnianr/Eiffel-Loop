note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 13:48:48 GMT (Wednesday 25th September 2024)"
	revision: "24"

class
	ZSTRING_DEVELOPER_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	XML_STRING_8_CONSTANTS

	EL_SHARED_FORMAT_FACTORY

create
	make

feature -- Access

	Description: STRING = "ZSTRING: development methods"

feature -- Basic operations

	execute
		local
			dir_step_list: EL_ARRAYED_LIST [DIR_PATH]; dir: DIR_PATH
			word_list: EL_STRING_8_LIST; i: INTEGER
		do
			if attached Text.latin_1_list.first.split (' ') as split_list then
				create word_list.make_from (split_list)
				create dir_step_list.make (word_list.count // 3)
				from i := 1 until i > 12 loop
					create dir.make_from_steps (word_list.sub_list (i, i + 2))
					i := i + 3
				end
			end
			compare ("perform benchmark", <<
				["method 1", agent do_method (1, dir_step_list)],
				["method 2", agent do_method (2, dir_step_list)]
			>>)
		end

feature {NONE} -- Implementation

	do_method (id: INTEGER; dir_step_list: EL_ARRAYED_LIST [DIR_PATH])
		local
			dir: DIR_PATH
		do
			across 1 |..| 100 as n loop
				inspect id
					when 1 then
						create dir
						across dir_step_list as list loop
							dir := dir.plus_dir (list.item)
						end
					when 2 then
						create dir
						across dir_step_list as list loop
							dir := dir.plus_dir_path (list.item.as_string_32)
						end
				end
			end
		end

feature {NONE} -- Operations


note
	notes: "[
		**plus_dir VS plus_dir_path**
		
			1. dir := dir.plus_dir (list.item)
			2. dir := dir.plus_dir_path (list.item.as_string_32)
			
			Passes over 2000 millisecs (in descending order)

				method 1 :  34885.0 times (100%)
				method 2 :  34792.0 times (-0.3%)
			
		**UTF-8 sequence count**
		
			if first_code <= 0x7F: 296.0 times (100%)
			bit-shifting         : 294.0 times (-0.7%)
	
		**XML header template comparison**
		
		Passes over 500 millisecs (in descending order)

			header: EL_ZSTRING             :  63.0 times (100%)
			header: EL_TEMPLATE [STRING_8] :  57.0 times (-9.5%)		
	
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
			
		**if boolean then VS inspect boolean_value when 1 then**

			boolean_value: NATURAL_8; boolean: BOOLEAN
					
		Passes over 500 millisecs (in descending order)

			if branch      : 194.0 times (100%)
			inspect branch : 194.0 times (-0.0%)
			
		**Hash Code Bitshifting Calculation**
			
		Passes over 2000 millisecs (in descending order)

			b.extended_hash (Result, area [i].code)                            : 1128.0 times (100%)
			((Result \\ 8388593) |<< 8) + area [i].code                        : 1125.0 times (-0.3%)
			((Result \\ {EL_BIT_ROUTINES}.Magic_number) |<< 8) + area [i].code : 1124.0 times (-0.4%)

	]"

end