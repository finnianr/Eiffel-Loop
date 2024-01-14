note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 14:36:24 GMT (Sunday 14th January 2024)"
	revision: "21"

class
	ZSTRING_DEVELOPER_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	XML_STRING_8_CONSTANTS

	EL_SHARED_FORMAT_FACTORY

create
	make

feature -- Access

	Description: STRING = "{ZSTRING} development methods"

feature -- Basic operations

	execute
		do
			compare ("perform benchmark", <<
				["if branch",		 agent do_method (1)],
				["inspect branch", agent do_method (2)]
			>>)
		end

feature {NONE} -- Implementation

	do_method (id: INTEGER)
		local
			divisible_by_2: BOOLEAN; divisible_by_2_bool: NATURAL_8
		do
			across 1 |..| 10_000 as n loop
				divisible_by_2 := divisible_by_2_bool.to_boolean; divisible_by_2_bool := (n.item \\ 2).to_natural_8
				inspect id
					when 1 then
						do_if_branch (divisible_by_2, divisible_by_2_bool)

					when 2 then
						do_inspect_branch (divisible_by_2, divisible_by_2_bool)
				end
			end
		end

feature {NONE} -- Operations

	do_if_branch (divisible_by_2: BOOLEAN; divisible_by_2_bool: NATURAL_8)
		do
			if divisible_by_2 then
				do_nothing
			end
		end

	do_inspect_branch (divisible_by_2: BOOLEAN; divisible_by_2_bool: NATURAL_8)
		do
			inspect divisible_by_2_bool
				when 1 then
					do_nothing
			else
			end
		end

note
	notes: "[
		**10 Dec 2023**
		
		XML header template comparison
		
		Passes over 500 millisecs (in descending order)

			header: EL_ZSTRING             :  63.0 times (100%)
			header: EL_TEMPLATE [STRING_8] :  57.0 times (-9.5%)		
	
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
			
		**if boolean then VS inspect boolean_value when 1 then**
					
		Passes over 500 millisecs (in descending order)

			if branch      : 194.0 times (100%)
			inspect branch : 194.0 times (-0.0%)	
	]"

end