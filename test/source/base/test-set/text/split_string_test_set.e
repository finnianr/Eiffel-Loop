﻿note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-28 13:55:05 GMT (Tuesday 28th March 2023)"
	revision: "43"

class
	SPLIT_STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_STRING_8_CONSTANTS

	EL_ENCODING_CONSTANTS

	EL_MODULE_CONVERT_STRING; EL_MODULE_TUPLE

	EL_SHARED_TEST_TEXT

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["across_iteration", agent test_across_iteration],
				["curtail_list", agent test_curtail_list],
				["fill_tuple", agent test_fill_tuple],
				["immutable_string_split", agent test_immutable_string_split],
				["occurrence_editor", agent test_occurrence_editor],
				["occurrence_intervals", agent test_occurrence_intervals],
				["path_split", agent test_path_split],
				["set_encoding_from_name", agent test_set_encoding_from_name],
				["skip_empty_split", agent test_skip_empty_split],
				["spell_numbers", agent test_spell_numbers],
				["split_and_join_1", agent test_split_and_join_1],
				["split_and_join_2", agent test_split_and_join_2],
				["split_and_join_3", agent test_split_and_join_3],
				["split_intervals", agent test_split_intervals],
				["split_iterator", agent test_split_iterator],
				["split_sort", agent test_split_sort],
				["split_string_8", agent test_split_string_8]
			>>)
		end

feature -- Tests

	test_across_iteration
		-- SPLIT_STRING_TEST_SET.test_across_iteration
		note
			testing: "covers/{EL_ARRAYED_INTERVALS_CURSOR}.item"
		local
			word_split: EL_SPLIT_INTERVALS; i, lower, upper: INTEGER
		do
			create word_split.make (Text.latin_1_lines.first, ' ')
			across word_split as split loop
				i := split.cursor_index
				lower := word_split.i_th_lower (i)
				upper := word_split.i_th_upper (i)
				assert ("same lower", split.item_lower = lower)
				assert ("same upper", split.item_upper = upper)
				if attached split.item as interval then
					assert ("same lower", interval.lower = lower)
					assert ("same upper", interval.upper = upper)
				end
			end
		end

	test_curtail_list
		-- SPLIT_STRING_TEST_SET.test_curtail_list
		note
			testing: "covers/{EL_STRING_LIST}.curtail",
				"covers/{EL_STRING_LIST}.keep_character_head",
				"covers/{EL_STRING_LIST}.keep_character_tail"
		local
			line_list: EL_ZSTRING_LIST; dots_index, tail_index: INTEGER
			meets_expectation: BOOLEAN
		do
			if attached Text.lines as text_lines then
				across 1 |..| text_lines.count as count loop
					create line_list.make_from_general (Text.lines.sub_list (1, count.item))
					line_list.curtail (100, 80)
					if attached line_list.joined_strings as joined then
						dots_index := joined.substring_index ("..", 1)
						if dots_index > 0 then
							tail_index := dots_index + 4
							meets_expectation := (joined.count - tail_index + 1) + dots_index - 1 = 100
						else
							meets_expectation := joined.count <= 100
						end
						if not meets_expectation then
							lio.put_labeled_lines ("Curtailed", line_list)
							lio.put_new_line
							assert ("curtailed to 100 characters leaving 80%% at head", False)
						end
					end
				end
			end
		end

	test_fill_tuple
		-- SPLIT_STRING_TEST_SET.test_fill_tuple
		local
			t1: TUPLE [animal: ZSTRING; letter: CHARACTER; weight: DOUBLE; age: INTEGER]
			t2: TUPLE [currency: STRING; symbol: STRING_32]
			data_lines: STRING_32; data_str: READABLE_STRING_GENERAL
			string_types: ARRAY [TYPE [ANY]]; type: TYPE [ANY]; is_string_8: BOOLEAN
		do
			data_lines := {STRING_32} "cat, C, 6.5, 4%NEuro, €"
			string_types := << {STRING_8}, {STRING_32}, {ZSTRING}, {IMMUTABLE_STRING_8}, {IMMUTABLE_STRING_32} >>

			across data_lines.split ('%N') as list loop
				data_str := list.item
				across string_types as types loop
					type := types.item
					if Convert_string.is_convertible (data_str, type) then
						if attached Convert_string.to_type (data_str, type) as general
							and then attached {READABLE_STRING_GENERAL} general as converted_str
						then
							data_str := converted_str
							if data_str.occurrences (',') = 3 then
								create t1
								Tuple.fill (t1, data_str)
								assert ("cat", t1.animal.same_string ("cat"))
								assert ("C", t1.letter = 'C')
								assert ("6.5 kg", t1.weight = 6.5)
								assert ("4 years", t1.age = 4)
							else
								create t2
								tuple.fill (t2, data_str)
								assert ("same currency", t2.currency ~ "Euro")
								assert ("same symbol", t2.symbol.count = 1 and data_lines.ends_with (t2.symbol))
							end
						end
					else
						is_string_8 := {ISE_RUNTIME}.type_conforms_to (type.type_id, ({READABLE_STRING_8}).type_id)
						assert ("euro not convertible to 8-bit string", data_str.starts_with ("Euro") and is_string_8)
					end
				end
			end
		end

	test_immutable_string_split
		-- SPLIT_STRING_TEST_SET.test_immutable_string_split
		local
			i: INTEGER; i_ching: HEXAGRAM_NAMES
			name: ZSTRING
		do
			if attached crc_generator as crc then
				from i := 1 until i > 64 loop
					name := i_ching.i_th_combined (i)
					crc.add_string (name)
					lio.put_labeled_string (i.out, name)
					if i > 1 and i \\ 8 = 0 then
						lio.put_new_line
					else
						lio.put_character (' ')
					end
					i := i + 1
				end
				lio.put_new_line
				assert ("checksum OK", crc.checksum = 3753697349)
			end
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

	test_spell_numbers
		-- SPLIT_STRING_TEST_SET.test_spell_numbers
		note
			testing: "covers/{EL_SPLIT_STRING_LIST}.append_i_th_to"
		local
			i: INTEGER; format: EL_FORMAT_INTEGER
			spelling: STRING
		do
			create format.make (1)
			if attached crc_generator as crc then
				from i := 0 until i > 99 loop
					spelling := Format.spell (i)
					crc.add_string_8 (spelling)
					lio.put_integer_field (spelling, i)
					if i > 1 and i \\ 7 = 0 then
						lio.put_new_line
					else
						lio.put_character (' ')
					end
					i := i + 1
				end
				lio.put_new_line
				assert ("checksum OK", crc.checksum = 1339904257)
			end
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
			create list.make_adjusted (Sales, ',', {EL_SIDE}.Left)
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
					adjustments := {EL_SIDE}.Both
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
				create split_list.make_adjusted (csv_list.item, ',', {EL_SIDE}.Left)
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