note
	description: "Test for [$source EL_BENCHMARK_COMMAND_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 10:16:17 GMT (Friday 18th May 2018)"
	revision: "5"

class
	BENCHMARK_COMMAND_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Benchmarks

	compare_list_iteration_methods
		local
			array: ARRAYED_LIST [INTEGER]; i: INTEGER; sum: INTEGER_REF
		do
			create array.make_filled (Iteration_count)
			from i := 1 until i > array.count loop
				array [i] := i
				i := i + 1
			end
			create sum
			compare ("compare_list_iteration_methods", <<
				["SPECIAL from i := 0 until i = count loop", agent iterate_special_from_i_until_i_eq_count (array.area, sum)],
				["from i := 1 until i > array.count loop", 	agent iterate_from_i_until_i_gt_count (array, sum)],
				["from array.start until array.after loop", 	agent iterate_start_after_forth (array, sum)],
				["across array as number loop",					agent iterate_across_array_as_n (array, sum)],
				["array.do_all (agent increment (sum, ?))",	agent iterate_do_all (array, sum)]
			>>)
		end

	compare_replace_substring
		do
			compare ("compare_replace_substring", <<
				["replace_substring_general_all", 	agent replace_substring_general_all],
				["replace_substring_all",				agent replace_substring_all]
			>>)
		end

	compare_string_concatenation
		local
			array: ARRAYED_LIST [STRING]
		do
			create array.make ((('z').natural_32_code - ('A').natural_32_code + 1).to_integer_32)
			from until array.full loop
				array.extend (create {STRING}.make_filled (('A').plus (array.count), 100))
			end
			compare ("compare_list_iteration_methods", <<
				["append strings to Result", 							agent string_append (array)],
				["append strings to once string", 					agent string_append_once_string (array)],
				["append strings to once string with local",		agent string_append_once_string_with_local (array)]
			>>)
		end

	compare_substring_index
		do
			compare ("compare_substring_index", <<
				["substring_index", 						agent substring_index],
				["substring_index_general",			agent substring_index_general]
			>>)
		end

feature {NONE} -- Iteration variations

	iterate_across_array_as_n (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			across array as number loop
				sum.set_item (sum.item + number.item)
			end
		end

	iterate_do_all (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			array.do_all (agent increment (sum, ?))
		end

	iterate_from_i_until_i_gt_count (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		local
			i: INTEGER
		do
			sum.set_item (0)
			from i := 1 until i > array.count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
			end
		end

	iterate_special_from_i_until_i_eq_count (array: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			sum.set_item (0); count := array.count
			from i := 0 until i = count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
			end
		end

	iterate_start_after_forth (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			from array.start until array.after loop
				sum.set_item (sum.item + array.item)
				array.forth
			end
		end

feature {NONE} -- String append variations

	string_append (array: ARRAYED_LIST [STRING]): STRING
		do
			create Result.make_empty
			from array.start until array.after loop
				Result.append (array.item)
				array.forth
			end
			Result.trim
		end

	string_append_once_string (array: ARRAYED_LIST [STRING]): STRING
		do
			Once_string.wipe_out
			from array.start until array.after loop
				Once_string.append (array.item)
				array.forth
			end
			Result := Once_string.twin
		end

	string_append_once_string_with_local (array: ARRAYED_LIST [STRING]): STRING
		local
			l_result: STRING
		do
			l_result := Once_string
			l_result.wipe_out
			from array.start until array.after loop
				l_result.append (array.item)
				array.forth
			end
			Result := l_result.twin
		end

feature -- replace_substring_all

	replace_substring_all
		local
			str: ZSTRING
		do
			str := Hexagram_1_description
			str.replace_substring_all (new_adapted (Chinese [1]), new_adapted (Chinese [2]))
		end

	replace_substring_general_all
		local
			str: ZSTRING
		do
			str := Hexagram_1_description
			str.replace_substring_general_all (Chinese [1], Chinese [2])
		end

feature -- substring_index

	substring_index
		local
			str: ZSTRING; pos: INTEGER
		do
			str := Hexagram_1_description
			pos := str.substring_index (new_adapted (Chinese [1]), 1)
		end

	substring_index_general
		local
			str: ZSTRING; pos: INTEGER
		do
			str := Hexagram_1_description
			pos := str.substring_index_general (Chinese [1], 1)
		end

feature {NONE} -- Implementation

	increment (a_sum: INTEGER_REF; n: INTEGER)
		do
			a_sum.set_item (a_sum.item + n)
		end

	new_adapted (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Compare list iteration methods", 	agent compare_list_iteration_methods],
				["Compare string concatenation methods", agent compare_string_concatenation],
				["Compare {ZSTRING}.replace_substring", agent compare_replace_substring],
				["Compare {ZSTRING}.substring_index", agent compare_substring_index]
			>>)
		end

feature {NONE} -- Constants

	Iteration_count: INTEGER
		once
			if Execution_environment.is_work_bench_mode then
				Result := 10_000
			else
				Result := 1_000_000
			end
		end

	Chinese: ARRAY [STRING_32]
		once
			Result := << {STRING_32} "(屯)", {STRING_32} "(乾)" >>
		end

	Hexagram_1_description: STRING_32 = "Hex. #1 - Qián (屯) - The Creative, Creating, Pure Yang, Inspiring Force, Dragon"

	Once_string: STRING
		once
			create Result.make_empty
		end
end
