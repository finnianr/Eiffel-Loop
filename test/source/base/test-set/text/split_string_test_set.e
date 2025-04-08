note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 15:58:33 GMT (Tuesday 8th April 2025)"
	revision: "72"

class SPLIT_STRING_TEST_SET inherit EL_EQA_TEST_SET

	EL_STRING_8_CONSTANTS

	EL_ENCODING_TYPE

	EL_MODULE_TUPLE

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32; EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["across_iteration",				 agent test_across_iteration],
				["adjusted_line_split",			 agent test_adjusted_line_split],
				["append_item_to",				 agent test_append_item_to],
				["append_string",					 agent test_append_string],
				["compact_zstring_list",		 agent test_compact_zstring_list],
				["immutable_grid_32",			 agent test_immutable_grid_32],
				["immutable_string_32_split",	 agent test_immutable_string_32_split],
				["item_count",						 agent test_item_count],
				["occurrence_editor",			 agent test_occurrence_editor],
				["occurrence_intervals",		 agent test_occurrence_intervals],
				["path_split",						 agent test_path_split],
				["set_encoding_from_name",		 agent test_set_encoding_from_name],
				["skip_empty_split",				 agent test_skip_empty_split],
				["spell_numbers",					 agent test_spell_numbers],
				["split_and_join_1",				 agent test_split_and_join_1],
				["split_and_join_2",				 agent test_split_and_join_2],
				["split_and_join_3",				 agent test_split_and_join_3],
				["split_immutable_utf_8_list", agent test_split_immutable_utf_8_list],
				["split_intervals",				 agent test_split_intervals],
				["split_iterator",				 agent test_split_iterator],
				["split_sort",						 agent test_split_sort],
				["split_string_8",				 agent test_split_string_8]
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
			create word_split.make (Text.lines_8.first, ' ')
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

	test_adjusted_line_split
		-- SPLIT_STRING_TEST_SET.test_adjusted_line_split
		local
			line_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
			list: EL_STRING_8_LIST; line_str: STRING
		do
			line_str := "one %N two %N three"
			create line_split.make_adjusted (line_str, '%N', {EL_SIDE}.Both)
			create list.make (3)
			across line_split as split loop
				list.extend (split.item_copy)
			end
			line_str.prune_all (' ')
			assert_same_string (Void, line_str, list.joined_lines)
		end

	test_append_item_to
		note
			testing: "covers/{EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR}.append_item_to"
		local
			str: ZSTRING; str_32: STRING_32
		do
			str := Text.Mixed_text
			create str_32.make (str.count)
			across str.split ('%N') as line loop
				if line.cursor_index > 1 then
					str_32.append_character ('%N')
				end
				line.append_item_to (str_32)
			end
			assert_same_string (Void, str_32, Text.Mixed_text)
		end

	test_append_string
		-- SPLIT_STRING_TEST_SET.test_append_string
		note
			testing: "covers/{EL_SPLIT_STRING_8_LIST}.append_string"
		local
			joined: EL_SPLIT_STRING_8_LIST
		do
			create joined.make_empty
			across << Number.one, Empty_string_8, Number.two >> as entry loop
				joined.append_string (entry.item)
			end
			across << Number.one, Empty_string_8, Number.two >> as entry loop
				assert_same_string (Void, joined.i_th (entry.cursor_index), entry.item)
			end
		end

	test_compact_zstring_list
		-- SPLIT_STRING_TEST_SET.test_compact_zstring_list
		note
			testing: "[
				covers/{EL_COMPACT_ZSTRING_LIST}.make,
				covers/{EL_COMPACT_ZSTRING_LIST}.query_if,
				covers/{EL_COMPACT_ZSTRING_LIST}.do_with,
				covers/{EL_SPLIT_IMMUTABLE_UTF_8_LIST}.make,
				covers/{EL_SPLIT_IMMUTABLE_UTF_8_LIST}.utf_8_strict_comparison,
				covers/{EL_COMPACT_ZSTRING_ITERATION_CURSOR}.item
			]"
		local
			compact_list: EL_COMPACT_ZSTRING_LIST; s32: EL_STRING_32_ROUTINES
			string_32_list: EL_STRING_32_LIST; i: INTEGER
			sub_list: EL_ZSTRING_LIST
		do
			string_32_list := Text.symbol_32_list
			create compact_list.make_general (string_32_list)
			assert ("same count", string_32_list.count = compact_list.count)

			if attached compact_list.query_if (agent is_control) as short_list then
				assert ("count = 1", short_list.count = 1)
				assert ("is tab", short_list.first.is_character ('%T'))
			end
			create sub_list.make_from_general (string_32_list.sub_list (1, 3))
			if attached compact_list.query_not_in (sub_list) as short_list then
				assert ("count = 2", short_list.count = 2)
				assert ("is tab", short_list.last.is_character ('%T'))
				assert ("is dollor", short_list.first.is_character ('$'))
			end

			across 1 |..| 2 as n loop
				across string_32_list as list loop
					i := list.cursor_index
					assert_same_string ("same i_th " + i.out, list.item, compact_list [i])
					compact_list.go_i_th (i)
					assert ("index_of = 1", compact_list.item_index_of (list.item [1]) = 1)
				end
				if n.item = 1 then
					compact_list.sort (True)
					string_32_list.sort (True)
				end
			end
			across compact_list as list loop
				i := list.cursor_index
				assert_same_string ("same i_th " + i.out, list.item, string_32_list [i])
			end
		end

	test_immutable_grid_32
		-- SPLIT_STRING_TEST_SET.test_immutable_grid_32
		local
			i: INTEGER; i_ching: HEXAGRAM_NAMES; name: ZSTRING
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

	test_immutable_string_32_split
		note
			testing: "covers/{EL_SPLIT_IMMUTABLE_STRING_LIST}.make_shared_adjusted"
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_32_LIST
			csv_list: EL_STRING_32_LIST
		do
			create split_list.make_shared_adjusted (Sales, ',', {EL_SIDE}.Left)
			csv_list := Sales
			assert ("same count", split_list.count = csv_list.count)
			if attached split_list as list then
				from list.start until list.after loop
					assert ("same item", list.item.same_string (csv_list [list.index]))
					list.forth
				end
			end
		end

	test_item_count
		local
			str: ZSTRING; has_item_count_zero: BOOLEAN
			list: EL_SEQUENTIAL_INTERVALS; s: EL_ZSTRING_ROUTINES
		do
			str := "A B C "
			list := str.split_intervals (s.character_string (' '))
			assert ("count is 4", list.count = 4)
			list.finish
			assert ("last item is empty", str.substring (list.item_lower, list.item_upper).is_empty)
			from list.start until has_item_count_zero or list.after loop
				if list.item_count = 0 then
					has_item_count_zero := True
				end
				list.forth
			end
			assert ("has_item_count_zero", has_item_count_zero)
		end

	test_occurrence_editor
		note
			testing: "[
				covers/{EL_STRING_32_OCCURRENCE_EDITOR}.apply,
				covers/{EL_STRING_8_OCCURRENCE_EDITOR}.apply
			]"
		local
			pair: STRING_TEST
		do
			across Text.lines_32 as line loop
				create pair.make (Current, line.item)
				assert ("occurrence edit OK", pair.occurrence_edit)
			end
		end

	test_occurrence_intervals
		-- SPLIT_STRING_TEST_SET.test_occurrence_intervals
		note
			testing: "covers/{EL_OCCURRENCE_INTERVALS}.make_by_string"
		local
			pair: STRING_TEST; start_index, end_index, space_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "occurrence_intervals OK"
			across Text.lines_32 as line loop
				create pair.make (Current, line.item)
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
			testing: "[
				covers/{EL_ITERABLE_SPLIT_CURSOR}.forth,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item
			]"
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
			character_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
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
			create format.make_width (1)
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

	test_split_immutable_utf_8_list
		-- SPLIT_STRING_TEST_SET.test_split_immutable_utf_8_list
		note
			testing: "[
				covers/{EL_SPLIT_IMMUTABLE_UTF_8_LIST}.make,
				covers/{EL_SPLIT_STRING_32_LIST}.character_count
			]"
		local
			utf_8_list: EL_SPLIT_IMMUTABLE_UTF_8_LIST
			symbol_32_list: EL_STRING_32_LIST
		do
			symbol_32_list := Text.symbol_32_list
			create utf_8_list.make (symbol_32_list)
			assert ("same count", utf_8_list.unicode_count = symbol_32_list.count)
		end

	test_split_intervals
		-- SPLIT_STRING_TEST_SET.test_split_intervals
		note
			testing: "[
				covers/{EL_SPLIT_INTERVALS}.make_by_string,
				covers/{EL_SPLIT_STRING_32_LIST}.make_by_string
			]"
		local
			pair: STRING_TEST; start_index, end_index, space_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "split_intervals OK"
			across << False, True >> as test_immutables loop
				across Text.lines_32 as line loop
					if test_immutables.item then
						create {IMMUTABLE_STRING_TEST} pair.make (Current, line.item)
					else
						create pair.make (Current, line.item)
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
								assert (assertion_ok, pair.split_lists)
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
			testing: "[
				covers/{EL_ITERABLE_SPLIT_CURSOR}.forth,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item_is_empty,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item_has,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item_copy,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item_same_as,
				covers/{EL_ITERABLE_SPLIT_CURSOR}.item_same_caseless_as
			]"
		local
			string_split: EL_SPLIT_ON_STRING [STRING]; character_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
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
						if attached split.item as str then
							if str.count > 0 and then str [1] = 'a' then
								assert ("has a", split.item_has ('a'))
								assert ("same as a", split.item_same_as ("a"))
								assert ("same as A", split.item_same_caseless_as ("A"))
							else
								assert ("zero implies empty item", str.count = 0 implies split.item_is_empty)
								assert ("not has a", not split.item_has ('a'))
								assert ("not same as a", not split.item_same_as ("a"))
								assert ("not same as A", not split.item_same_caseless_as ("A"))
							end
						end
						split_list.extend (split.item_copy)
					end
					assert ("same_list", same_list (split_list, csv_list.item))
				end
			end
		end

	test_split_sort
		-- SPLIT_STRING_TEST_SET.test_split_sort
		note
			testing: "[
				covers/{EL_SPLIT_READABLE_STRING_LIST}.sort,
				covers/{EL_SPLIT_READABLE_STRING_LIST}.i_th,
				covers/{EL_SPLIT_ZSTRING_LIST}.string_strict_cmp,
				covers/{ZSTRING}.order_comparison
			]"
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
			copied_list.ascending_sort
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
		local
			split_list: EL_SPLIT_READABLE_STRING_LIST [STRING]; str_split: LIST [STRING]
			list_2: EL_SPLIT_STRING_LIST [STRING_32]
		do
			create split_list.make_empty
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

	is_control (str: ZSTRING): BOOLEAN
		-- Is `item' a control character?
		do
			Result := str.count = 1 and then str [1].is_control
		end

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

	Number: TUPLE [one, two, three: STRING]
		once
			create Result
			Tuple.fill (Result, Numbers)
		end

	Numbers: STRING = "one,two,three"

	Sales: STRING_32 = "widget, €10, in stock"

	Unix_path: STRING = "/home/joe"
end