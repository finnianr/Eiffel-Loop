note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 12:20:03 GMT (Wednesday 8th March 2023)"
	revision: "31"

class
	SPLIT_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_STRING_8_CONSTANTS

	EL_ENCODING_CONSTANTS

	EL_MODULE_TUPLE

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("fill_tuple", agent test_fill_tuple)
			eval.call ("occurrence_editor", agent test_occurrence_editor)
			eval.call ("occurrence_intervals", agent test_occurrence_intervals)
			eval.call ("path_split", agent test_path_split)
			eval.call ("set_encoding_from_name", agent test_set_encoding_from_name)
			eval.call ("skip_empty_split", agent test_skip_empty_split)
			eval.call ("split_and_join_1", agent test_split_and_join_1)
			eval.call ("split_and_join_2", agent test_split_and_join_2)
			eval.call ("split_and_join_3", agent test_split_and_join_3)
			eval.call ("split_intervals", agent test_split_intervals)
			eval.call ("split_iterator", agent test_split_iterator)
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
			lio.put_string_field ("SYMBOL " + t2.symbol.generator, t2.symbol)
			lio.put_new_line
			assert ("same symbol", t2.symbol ~ {STRING_32} "€")
		end

	test_occurrence_editor
		note
			testing: "covers/{EL_STRING_32_OCCURRENCE_EDITOR}.apply",
				"covers/{EL_STRING_8_OCCURRENCE_EDITOR}.apply"
		local
			pair: STRING_PAIR
		do
			across Text.lines as line loop
				pair := line.item
				assert ("occurrence edit OK", pair.occurrence_edit)
			end
		end

	test_occurrence_intervals
		-- SPLIT_STRING_TEST_SET.test_occurrence_intervals
		note
			testing: "covers/{EL_OCCURRENCE_INTERVALS}.make_by_string"
		local
			pair: STRING_PAIR; start_index, end_index, space_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "occurrence_intervals OK"
			across Text.lines as line loop
				create pair.make (line.item)
				space_index := pair.s_32.index_of (' ', 1)
				if space_index > 0 then
					pair.set_substrings (space_index, space_index)
					assert (assertion_ok, pair.occurrence_intervals)
				end
				across pair.all_word_interval_permutations as permutation loop
					if attached permutation.item as list then
						from list.start until list.after loop
							start_index := list.item_lower; end_index := list.item_upper
							pair.set_substrings (start_index, end_index)
							assert (assertion_ok, pair.occurrence_intervals)
							list.forth
						end
					end
				end
			end
		end

	test_path_split
		local
			list: LIST [STRING]; split_8_path: EL_SPLIT_STRING_LIST [STRING]
			split_path: EL_SPLIT_ZSTRING_LIST; l_path: STRING; i: INTEGER
			item: STRING
		do
			list := Unix_path.split ('/')
			l_path := Unix_path.twin
			across 1 |..| 2 as n loop
				create split_path.make_by_string (l_path, "/")
				across list as step loop
					item := step.item; i := step.cursor_index
					assert ("same step", item ~ split_path.i_th (i).to_string_8)
				end

				create split_8_path.make_by_string (l_path, "/")
				across list as step loop
					item := step.item; i := step.cursor_index
					assert ("same step", item ~ split_path.i_th (i))
				end
				l_path.append_character ('/')
			end
		end

	test_set_encoding_from_name
		note
			testing: "covers/{EL_ITERABLE_SPLIT_CURSOR}.forth, covers/{EL_ITERABLE_SPLIT_CURSOR}.item"
		local
			encodeable: EL_ENCODEABLE_AS_TEXT; name: STRING
		do
			create encodeable.make_default
			across << False, True >> as is_lower_case loop
				across ("ISO-8859-1,UTF-8,WINDOWS-1252").split (',') as split loop
					name := split.item
					if is_lower_case.item then
						name.to_lower
					end
					encodeable.set_encoding_from_name (name)
					inspect split.cursor_index
						when 1 then
							assert ("is ISO-8859-1", encodeable.encoded_as_latin (1))
						when 2 then
							assert ("UTF-8", encodeable.encoded_as_utf (8))
						when 3 then
							assert ("WINDOWS-1252", encodeable.encoded_as_windows (1252))
					else
					end
					assert ("same upper name", name.as_upper ~ encodeable.encoding_name)
				end
			end
		end

	test_skip_empty_split
		note
			testing: "covers/{EL_SPLIT_ON_CHARACTER}.new_cursor"
		local
			character_split: EL_SPLIT_ON_CHARACTER [STRING]
			split_list: EL_STRING_8_LIST
		do
			create character_split.make (",a,b,c,", ',')
			create split_list.make_empty
			across character_split as split loop
				if not split.item_is_empty then
					split_list.extend (split.item_copy)
				end
			end
			assert ("same_list", same_list (split_list, "a,b,c"))
		end

	test_split_and_join_1
		-- SPLIT_STRING_TEST_SET.test_split_and_join_1
		local
			list: EL_STRING_LIST [STRING]
		do
			create list.make_split (Numbers, ',')
			assert ("same string", Numbers ~ list.joined (','))

			list := << "one", "two", "three" >>
			assert ("same string", Numbers ~ list.joined (','))
		end

	test_split_and_join_2
		local
			list: EL_SPLIT_ZSTRING_LIST
		do
			create list.make_by_string (Numbers, ",")
			assert ("same string", Numbers ~ list.joined (','))
		end

	test_split_and_join_3
		local
			list: EL_SPLIT_STRING_32_LIST
		do
			create list.make_adjusted (Sales, ',', {EL_STRING_ADJUST}.Left)
			from list.start until list.after loop
				lio.put_string_field (list.index.out, list.item)
				lio.put_new_line
				list.forth
			end
			assert ("same string", Sales ~ list.joined_with_string (", "))
		end

	test_split_intervals
		-- SPLIT_STRING_TEST_SET.test_split_intervals
		note
			testing: "covers/{EL_SPLIT_INTERVALS}.make_by_string"
		local
			pair: STRING_PAIR; start_index, end_index, space_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "split_intervals OK"
			across << False, True >> as test_immutables loop
				across Text.lines as line loop
					if test_immutables.item then
						create {IMMUTABLE_STRING_PAIR} pair.make (line.item)
					else
						create pair.make (line.item)
					end
					space_index := pair.s_32.index_of (' ', 1)
					if space_index > 0 then
						pair.set_substrings (space_index, space_index)
						assert (assertion_ok, pair.split_intervals)
					end
					across pair.all_word_interval_permutations as permutation loop
						if attached permutation.item as list then
							from list.start until list.after loop
								start_index := list.item_lower; end_index := list.item_upper
								pair.set_substrings (start_index, end_index)
								assert (assertion_ok, pair.split_intervals)
								list.forth
							end
						end
					end
				end
			end
		end

	test_split_iterator
		note
			testing: "covers/{EL_ITERABLE_SPLIT_CURSOR}.forth, covers/{EL_ITERABLE_SPLIT_CURSOR}.item,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_is_empty,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_copy,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_same_as,%
						%covers/{EL_ITERABLE_SPLIT_CURSOR}.item_same_caseless_as"
		local
			string_split: EL_SPLIT_ON_STRING [STRING]; character_split: EL_SPLIT_ON_CHARACTER [STRING]
			splitter_array: ARRAY [EL_ITERABLE_SPLIT [STRING, ANY]]
			split_list: EL_STRING_8_LIST; str_list, bracket_pair, first_item: STRING
			adjustments: INTEGER
		do
			bracket_pair := "()"
			across Comma_separated_variations as csv_list loop
				if csv_list.item.has (' ') then
					adjustments := {EL_STRING_ADJUST}.Both
				else
					adjustments := 0
				end
				create character_split.make_adjusted (csv_list.item, ',', adjustments)

				str_list := csv_list.item.twin
				str_list.replace_substring_all (",", bracket_pair)
				create string_split.make_adjusted (str_list, bracket_pair, adjustments)

				splitter_array := << string_split, character_split >>
				across splitter_array as splitter loop
					create split_list.make (5)
					across splitter.item as split loop
						if split.cursor_index = 1 then
							first_item := split.item
						else
							assert ("same string instance", first_item = split.item)
						end
						if not split.item_is_empty and then split.item [1] = 'a' then
							assert ("same as a", split.item_same_as ("a"))
							assert ("same as A", split.item_same_caseless_as ("A"))
						end
						split_list.extend (split.item_copy)
					end
					assert ("same_list", same_list (split_list, csv_list.item))
				end
			end
		end

	test_split_sort
		note
			testing: "covers/{EL_SPLIT_READABLE_STRING_LIST}.sort", "covers/{EL_SPLIT_READABLE_STRING_LIST}.i_th",
				"covers/{EL_SPLIT_ZSTRING_LIST}.string_strict_cmp", "covers/{ZSTRING}.order_comparison"
		local
			split_list: EL_SPLIT_STRING_LIST [STRING]; copied_list: EL_STRING_8_LIST
			split_zstring_list: EL_SPLIT_ZSTRING_LIST
			csv_list: STRING
		do
			csv_list := "ZAB, ZAC, ZAC1, ZA, CAL, CON, CAT, CAN, CANOPY"
			create split_list.make_by_string (csv_list, Comma_space)
			create split_zstring_list.make_by_string (csv_list, Comma_space)
			create copied_list.make (split_list.count)
			across split_list as list loop
				copied_list.extend (list.item_copy)
			end
			copied_list.sort
			split_list.sort (True)
			across copied_list as list loop
				assert ("same substring", list.item ~ split_list.i_th (list.cursor_index))
			end

			split_zstring_list.sort (True)
			across copied_list as list loop
				assert ("same substring", list.item ~ split_zstring_list.i_th (list.cursor_index))
			end
		end

	test_split_string_8
		note
			testing: "covers/{EL_SPLIT_STRING_LIST}.make", "covers/{EL_FILLED_STRING_8_TABLE}.item"
		local
			split_list: EL_SPLIT_STRING_LIST [STRING]; str_split: LIST [STRING]
		do
			across Comma_separated_variations as csv_list loop
				create split_list.make_adjusted (csv_list.item, ',', {EL_STRING_ADJUST}.Left)
				str_split := csv_list.item.split (',')
				if attached split_list as list then
					from list.start until list.after loop
						str_split.go_i_th (list.index)
						str_split.item.left_adjust
						assert ("same_item_as", list.item_same_as (str_split.item))
						assert ("equal items", list.item ~ str_split.item)
						list.forth
					end
				end
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

	Comma_separated_variations: ARRAY [STRING]
		once
			Result := << ",a,b,c,", "a,b,c", " a, b , c ", "" >>
		end

	Numbers: STRING = "one,two,three"

	Sales: STRING_32 = "widget, €10, in stock"

	Unix_path: STRING = "/home/joe"
end