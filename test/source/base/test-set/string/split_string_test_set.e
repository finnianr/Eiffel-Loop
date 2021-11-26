note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 11:35:49 GMT (Friday 26th November 2021)"
	revision: "15"

class
	SPLIT_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_STRING_8_CONSTANTS

	EL_MODULE_LIO

	EL_MODULE_TUPLE

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("fill_tuple", agent test_fill_tuple)
			eval.call ("occurrence_intervals", agent test_occurrence_intervals)
			eval.call ("path_split", agent test_path_split)
			eval.call ("split_and_join_1", agent test_split_and_join_1)
			eval.call ("split_and_join_2", agent test_split_and_join_2)
			eval.call ("split_and_join_3", agent test_split_and_join_3)
			eval.call ("split_iterator", agent test_split_iterator)
			eval.call ("skip_empty_split", agent test_skip_empty_split)
			eval.call ("split_sort", agent test_split_sort)
			eval.call ("split_string_8", agent test_split_string_8)
		end

feature -- Tests

	test_fill_tuple
		local
			t1: TUPLE [animal: STRING; letter: CHARACTER; weight: DOUBLE; age: INTEGER]
			t2: TUPLE [currency: STRING; symbol: STRING_32]
		do
			create t1
			Tuple.fill (t1, "cat, C, 6.5, 4")
			assert ("cat", t1.animal ~ "cat")
			assert ("C", t1.letter = 'C')
			assert ("6.5 kg", t1.weight = 6.5)
			assert ("4 years", t1.age = 4)

			create t2
			tuple.fill (t2, {STRING_32} "euro, €")
			assert ("same currency", t2.currency ~ "euro")
			assert ("same symbol", t2.symbol ~ {STRING_32} "€")
		end

	test_occurrence_intervals
		local
			intervals: EL_OCCURRENCE_INTERVALS [STRING]
			str: STRING; item_lower, item_upper: INTEGER
		do
			create intervals.make (Api_string_list.joined_with_string (Comma_space), Comma_space)
			create str.make (Api_string.count)
			across Api_string_list as api loop
				if not str.is_empty then
					item_lower := str.count + 1
					str.append (Comma_space)
					item_upper := str.count
					intervals.go_i_th (api.cursor_index - 1)
					assert ("same item_lower", item_lower = intervals.item_lower)
					assert ("same item_upper", item_upper = intervals.item_upper)
				end
				str.append (api.item)
			end
		end

	test_path_split
		local
			list: LIST [STRING]; split_8_path: EL_SPLIT_STRING_LIST [STRING]
			split_path: EL_SPLIT_ZSTRING_LIST; l_path: STRING
		do
			list := Unix_path.split ('/')
			l_path := Unix_path.twin
			across 1 |..| 2 as n loop
				create split_path.make (l_path, "/")
				across list as step loop
					assert ("same step", step.item ~ split_path.i_th (step.cursor_index).to_string_8)
				end

				create split_8_path.make (l_path, "/")
				across list as step loop
					assert ("same step", step.item ~ split_path.i_th (step.cursor_index))
				end
				l_path.append_character ('/')
			end
		end

	test_skip_empty_split
		note
			testing: "covers/{EL_ITERABLE_SPLIT}.set_skip_empty"
		local
			character_split: EL_SPLIT_ON_CHARACTER [STRING]
			split_list: EL_STRING_8_LIST
		do
			create character_split.make (",a,b,c,", ',')
			character_split.set_skip_empty (True)
			split_list.wipe_out
			across character_split as split loop
				split_list.extend (split.item_copy)
			end
			assert ("same_list", same_list (split_list, "a,b,c"))
		end

	test_split_and_join_1
		local
			list: EL_STRING_LIST [STRING]
		do
			create list.make_with_separator (Numbers, ',', False)
			assert ("same string", Numbers ~ list.joined (','))

			list := << "one", "two", "three" >>
			assert ("same string", Numbers ~ list.joined (','))
		end

	test_split_and_join_2
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			create list.make (Numbers, ",")
			assert ("same string", Numbers ~ list.joined (','))
		end

	test_split_and_join_3
		local
			list: EL_SPLIT_STRING_32_LIST
		do
			create list.make (Sales, ",")
			list.enable_left_adjust
			from list.start until list.after loop
				lio.put_string_field (list.index.out, list.item (False))
				lio.put_new_line
				list.forth
			end
			assert ("same string", Sales ~ list.joined_with_string (", "))
		end

	test_split_iterator
		note
			testing: "covers/{EL_ITERABLE_SPLIT_CURSOR}.forth, covers/{EL_ITERABLE_SPLIT_CURSOR}.item,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_copy"
		local
			string_split: EL_SPLIT_ON_STRING [STRING]; character_split: EL_SPLIT_ON_CHARACTER [STRING]
			splitter_array: ARRAY [EL_ITERABLE_SPLIT [STRING, ANY]]
			split_list: EL_STRING_8_LIST; str_list, bracket_pair, first_item: STRING
			is_first_item: BOOLEAN
		do
			bracket_pair := "()"
			across << ",a,b,c,", "a,b,c", " a, b , c " >> as csv_list loop
				create character_split.make (csv_list.item, ',')

				str_list := csv_list.item.twin
				str_list.replace_substring_all (",", bracket_pair)
				create string_split.make (str_list, bracket_pair)

				splitter_array := << string_split, character_split >>
				across splitter_array as splitter loop
					if csv_list.item.has (' ') then
						splitter.item.set_left_adjusted (True)
						splitter.item.set_right_adjusted (True)
					end
					create split_list.make (5)
					is_first_item := True
					across splitter.item as split loop
						if is_first_item then
							is_first_item := False
							first_item := split.item
						else
							assert ("same string instance", first_item = split.item)
						end
						split_list.extend (split.item_copy)
					end
					assert ("same_list", same_list (split_list, csv_list.item))
				end
			end
		end

	test_split_sort
		local
			split: EL_SPLIT_STRING_LIST [STRING]
			list: EL_STRING_8_LIST
		do
			create split.make ("ZAB, ZAC, ZAC1, ZA, CAL, CON, CAT, CAN, CANOPY", Comma_space)
			create list.make (split.count)
			across split as animal loop
				list.extend (animal.item)
			end
			list.sort
			split.sort (True)
			across list as animal loop
				assert ("same animal", animal.item ~ split.i_th (animal.cursor_index))
			end
		end

	test_split_string_8
		note
			testing: "covers/{EL_SPLIT_STRING_LIST}.make", "covers/{EL_FILLED_STRING_8_TABLE}.item"
		local
			list: EL_SPLIT_STRING_LIST [STRING]; s: EL_STRING_8_ROUTINES
		do
			create list.make (Api_string_list.joined_with_string (Comma_space), s.character_string (','))
			list.enable_left_adjust
			from list.start until list.after loop
				assert ("same item", list.same_item_as (Api_string_list.i_th (list.index)))
				list.forth
			end
		end

feature {NONE} -- Implementation

	same_list (split_list: EL_STRING_8_LIST; str: STRING): BOOLEAN
		do
			if attached str.split (',') as str_split and then str_split.count = split_list.count then
				str_split.do_all (agent {STRING}.adjust)
				Result := across str_split as split all split.item ~ split_list [split.cursor_index]  end
			end
		end

feature {NONE} -- Constants

	Api_string: STRING = "[
		DTA1-HMAC-SHA256 SignedHeaders=content-length;content-type;host;x-amz-date
		Credential=PUBLIC/20200124
		Signature=B7387390DEC2CD5A515B67EE50D220A3EE4507DC2F71EA67F59BDB0DE9FF403B
	]"

	Api_string_list: EL_STRING_8_LIST
		once
			create Result.make_with_lines (Api_string)
		end

	Comma_space: STRING = ", "

	Numbers: STRING = "one,two,three"

	Sales: STRING_32 = "widget, €10, in stock"

	Unix_path: STRING = "/home/joe"
end