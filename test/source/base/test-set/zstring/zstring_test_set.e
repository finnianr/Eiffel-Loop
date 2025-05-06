note
	description: "Tests for class ${EL_ZSTRING}"
	notes: "[
		Don't forget to also run the test with the ISO-8859-1 codec specified on command line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 7:38:51 GMT (Tuesday 6th May 2025)"
	revision: "146"

class
	ZSTRING_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

	EL_STRING_32_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	EL_SHARED_STRING_32_BUFFER_POOL; EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["fill_with_z_code",					agent test_fill_with_z_code],
				["shared_z_code_pattern",			agent test_shared_z_code_pattern],
				["substring_split",					agent test_substring_split],
				["to_general",							agent test_to_general],
				["remove_double",						agent test_remove_double],
				["remove_substring",					agent test_remove_substring],
				["insert_character",					agent test_insert_character],
				["insert_remove",						agent test_insert_remove],
				["joined",								agent test_joined],
				["put_unicode",						agent test_put_unicode],
				["share_8",								agent test_share_8],
				["fill_alpha_numeric_intervals",	agent test_fill_alpha_numeric_intervals],
				["for_all_split",						agent test_for_all_split],
				["has",									agent test_has],
				["has_between",						agent test_has_between],
				["has_enclosing",						agent test_has_enclosing],
				["is_alpha_numeric",					agent test_is_alpha_numeric],
				["is_canonically_spaced",			agent test_is_canonically_spaced],
				["order_comparison",					agent test_order_comparison],
				["sort",									agent test_sort],
				["substring_index_list",			agent test_substring_index_list],
				["there_exists_split",				agent test_there_exists_split],
				["remove",								agent test_remove],
				["hash_code",							agent test_hash_code],
				["index_of",							agent test_index_of],
				["last_index_of",						agent test_last_index_of],
				["new_cursor",							agent test_new_cursor],
				["occurrences",						agent test_occurrences],
				["substring_index",					agent test_substring_index],
				["substring_index_in_bounds",		agent test_substring_index_in_bounds],
				["unicode_index_of",					agent test_unicode_index_of],
				["substitute_tuple",					agent test_substitute_tuple],
				["substring",							agent test_substring],
				["substring_to",						agent test_substring_to],
				["substring_to_reversed",			agent test_substring_to_reversed]
			>>)
		end

feature -- General tests

	test_fill_with_z_code
		-- ZSTRING_TEST_SET.test_fill_with_z_code
		note
			testing:	"[
				covers/{EL_READABLE_ZSTRING}.make_from_zcode_area,
				covers/{EL_WRITEABLE_ZSTRING}.fill_with_z_code,
				covers/{EL_EXTENDED_ZSTRING}.to_z_code_array,
				covers/{EL_EXTENDED_READABLE_STRING_32_I}.to_code_array
			]"
		local
			zstr, zstr_2: ZSTRING; str_32: STRING_32
		do
			create str_32.make_empty
			across Text.words_32 as list loop
				zstr := list.item
				zstr.fill_z_codes (str_32)
				if attached super_32 (str_32).to_code_array as code_array then
					create zstr_2.make_from_zcode_area (code_array)
					assert_same_string (Void, zstr, zstr_2)
					assert ("same z codes", code_array ~ super_z (zstr).to_z_code_array)
				end
			end
		end

feature -- Conversion tests

	test_shared_z_code_pattern
		-- ZSTRING_TEST_SET.test_shared_z_code_pattern
		note
			testing:	"[
				covers/{EL_SEARCHABLE_ZSTRING}.shared_z_code_pattern,
				covers/{EL_STRING_32_BUFFER_I}.copied_z_codes
			]"
		local
			z_code_string: STRING_32; general: READABLE_STRING_GENERAL
			test: STRING_TEST; i: INTEGER
		do
			create test.make_empty (Current)
		 	across Text.lines_32 as line loop
		 		test.set (line.item)
		 		if attached String_32_pool.sufficient_item (test.zs.count) as borrowed then
			 		z_code_string := borrowed.copied_z_codes (test.zs)
			 		if z_code_string.count = test.zs.count then
			 			general := test.zs
			 			from i := 1 until i > z_code_string.count loop
			 				assert ("same code", general.code (i) = z_code_string.code (i))
			 				i := i + 1
			 			end
			 		else
			 			failed ("expanded same length")
			 		end
			 		borrowed.return
		 		end
		 	end
		end

	test_substring_split
		note
			testing: "[
				covers/{ZSTRING}.substring_split,
				covers/{ZSTRING}.split_intervals,
				covers/{ZSTRING}.substring_intervals,
				covers/{EL_ZSTRING_SEARCHER}.initialize_z_code_deltas_for_type,
				covers/{EL_EXTENDED_READABLE_STRING_I}.fill_z_codes
			]"
		local
			str, delimiter, str_2, l_substring: ZSTRING
		do
			across Text.lines_32 as line loop
				str := line.item
				from delimiter := " "  until delimiter.count > 2 loop
					create str_2.make_empty
					across str.substring_split (delimiter) as substring loop
						l_substring := substring.item
						if substring.cursor_index > 1 then
							str_2.append (delimiter)
						end
						str_2.append (l_substring)
					end
					assert ("substring_split OK", str ~ str_2)
					delimiter.prepend_character ('и')
				end
			end
			str := Text.Mixed_text; delimiter := "Latin"
			across str.substring_split (delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert_same_string ("substring_split OK", str, Text.Mixed_text)
		end

	test_to_general
		-- ZSTRING_TEST_SET.test_to_general
		note
			testing:	"[
				covers/{ZSTRING}.to_general,
				covers/{ZSTRING}.make_from_general
			]"
		local
			test: STRING_TEST
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line.item)
				assert ("to_general OK", test.to_general)
			end
		end

feature -- Removal tests

	test_remove_double
		-- ZSTRING_TEST_SET.test_remove_double
		note
			testing: "covers/{ZSTRING}.remove_double"
		local
			double_quotes, quoted, str: ZSTRING
		do
			create double_quotes.make_filled ('"', 2)
			across Text.words_32 as word loop
				str := word.item
				quoted := double_quotes.twin
				quoted.insert_string (str, 2)
				assert ("in quotes", quoted [2] = str [1] and quoted [quoted.count - 1] = str [str.count])
				quoted.remove_double
				assert ("same word", quoted ~ str)
			end
		end

	test_remove_substring
		note
			testing: "covers/{ZSTRING}.remove_substring"
		local
			test: STRING_TEST; substring: STRING_32
			l_interval: INTEGER_INTERVAL; i, lower, upper, offset: INTEGER
		do
			create test.make_empty (Current)
			across Text.word_intervals as interval loop
				from offset := 0 until offset > (interval.item.count // 2).max (1) loop
					l_interval := (interval.item.lower + offset) |..| (interval.item.upper + offset)
					if Text.Mixed_text.valid_index (l_interval.lower)
						and then Text.Mixed_text.valid_index (l_interval.upper)
					then
						substring := Text.Mixed_text.substring (l_interval.lower, l_interval.upper) -- Debug
						test.set (Text.Mixed_text.twin)
						test.s_32.remove_substring (l_interval.lower, l_interval.upper)
						test.zs.remove_substring (l_interval.lower, l_interval.upper)
						assert ("remove_substring OK", test.is_same)
					end
					offset := offset + (interval.item.count // 2).max (1)
				end
			end
			across Text.words_32 as word loop
				test.set (word.item)
				test.zs.remove_substring (1, test.zs.count)
				test.s_32.remove_substring (1, test.s_32.count)
				assert ("empty string", test.s_32.is_empty)
				assert ("same strings", test.is_same)
			end
		end

feature -- Element change tests

	test_insert_character
		note
			testing:	"covers/{ZSTRING}.insert_character"
		local
			str_32, word_32: STRING_32; word: ZSTRING; uc_1, uc_2: CHARACTER_32
		do
			across Text.words_32 as list loop
				word_32 := list.item
				if word_32.count > 1 then
					word := word_32
					uc_1 := word_32 [1]; uc_2 := word_32 [word_32.count]
					word := word_32.substring (2, word_32.count - 1)
					word.insert_character (uc_1, 1)
					word.insert_character (uc_2, word.count + 1)
					assert_same_string ("insert_character OK", word, word_32)
				end
			end
		end

	test_insert_remove
		note
			testing:	"[
				covers/{ZSTRING}.insert_string, 
				covers/{ZSTRING}.remove_substring,
				covers/{EL_COMPACT_SUBSTRINGS_32}.shift_from
			]"
		local
			test: STRING_TEST; G_clef: ZSTRING; word_list: EL_SPLIT_ZSTRING_LIST
			start_index, mid_index, end_index: INTEGER
		do
			create test.make_empty (Current)
			G_clef := Text.G_clef
			across Text.lines_32 as line loop
				test.set (line.item)
				create word_list.make_by_string (test.s_32, " ")
				from word_list.start until word_list.after loop
					start_index := word_list.item_lower; end_index := word_list.item_upper
					mid_index := start_index + word_list.item_count // 2
					if start_index <= mid_index and mid_index <= end_index then
						across << G_clef, space * 2 >> as insert loop
						-- insert into middle of word
							assert ("insert_remove OK", test.insert_remove (insert.item, mid_index))
						end
					end
					word_list.forth
				end
			end
		end

	test_joined
		note
			testing:	"covers/{ZSTRING}.joined"
		local
			line, joined: ZSTRING; line_32: STRING_32
		do
			across Text.lines_32 as list loop
				line_32 := list.item.twin; line := line_32
				line_32.append_string_general (" 100-abc")
				joined := line.joined ([' ', 100, "-abc"])
				assert_same_string ("line not modified", line, list.item)
				assert_same_string ("same joined", joined, line_32)
			end
		end

	test_put_unicode
		note
			testing: "[
				covers/{ZSTRING}.put_unicode,
				covers/{ZSTRING}.put_z_code
			]"
		local
			test: STRING_TEST; uc, old_uc: CHARACTER_32; i: INTEGER
			z_code, old_z_code: NATURAL
		do
			uc := 'д'; z_code := Codec.as_z_code (uc)
			test := new_test (Text.cyrillic_line_32)
			across << true, false >> as test_put_z_code loop
				across Text.cyrillic_line_32 as c loop
					i := c.cursor_index; old_uc := c.item
					old_z_code := Codec.as_z_code (old_uc)

					test.s_32.put (uc, i)
					if test_put_z_code.item then
						test.zs.put_z_code (z_code, i)
					else
						test.zs.put (uc, i)
					end
					assert ("put_unicode OK", test.is_same)
				--	Restore
					test.s_32.put (old_uc, i)
					if test_put_z_code.item then
						test.zs.put_z_code (old_z_code, i)
					else
						test.zs.put (old_uc, i)
					end
					assert ("put_unicode OK", test.is_same)
				end
			end
		end

	test_share_8
		-- ZSTRING_TEST_SET.test_share_8
		note
			testing: "[
				covers/{EL_READABLE_ZSTRING}.is_shareable_8,
				covers/{EL_READABLE_ZSTRING}.share_8,
				covers/{EL_ZCODEC}.is_compatible_string_8
			]"
		local
			latin_1: STRING; zstr: ZSTRING
			shareable_indices: EL_BOOLEAN_INDEXABLE [ARRAY [INTEGER]]
		do
			create shareable_indices.make (
				<< 2, 3, 5 >>,		-- shareable for ISO-8859-15
				<< 2, 3, 4, 6 >>	-- shareable for ISO-8859-1
			)
			across Text.lines_32 as list loop
				if list.item.is_valid_as_string_8 then
					latin_1 := list.item.to_string_8
					create zstr.make_empty
					if zstr.is_shareable_8 (latin_1) then
						zstr.share_8 (latin_1)
						if not shareable_indices [Codec.id = 1].has (list.cursor_index) then
							failed ("valid list item")
						end
						assert ("same string", zstr.to_string_32 ~ list.item)
					end
				end
			end
		end

feature -- Status query tests

	test_fill_alpha_numeric_intervals
		note
			testing: "covers/{EL_SEARCHABLE_ZSTRING}.fill_alpha_numeric_intervals"
		local
			word_intervals, alpha_numeric_intervals: EL_SPLIT_INTERVALS
			zstr: ZSTRING
		do
			create alpha_numeric_intervals.make_empty
			across 1 |..| 2 as n loop
				across Text.lines_32 as list until list.cursor_index > 3 loop
					list.item.prune_all (',')
					if n.item = 2 then
						list.item.prepend_character (' ')
						list.item.append_character (' ')
					end
					create word_intervals.make (list.item, ' ')
					if n.item = 2 then
						word_intervals.remove_head (1)
						word_intervals.remove_tail (1)
					end
					zstr := list.item
					zstr.fill_alpha_numeric_intervals (alpha_numeric_intervals)
					assert ("same intervals", word_intervals ~ alpha_numeric_intervals)
				end
			end
		end

	test_for_all_split
		note
			testing: "covers/{ZSTRING}.for_all_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST
		do
			across Text.lines_32 as line_32 loop
				line := line_32.item
				create word_list.make_word_split (line)
				assert ("word is in word_list", line.for_all_split (space, agent word_list.has))
			end
		end

	test_has
		note
			testing: "covers/{EL_READABLE_ZSTRING}.has"
		local
			english: ZSTRING; english_32: STRING_32
		do
			english_32 := Text.lines_32.last
			english := english_32
			across Text.lines_32 as line loop
				across line.item as uc loop
					assert ("has OK", english.has (uc.item) ~ english_32.has (uc.item))
				end
			end
		end

	test_has_between
		-- ZSTRING_TEST_SET.test_has_between
		note
			testing: "covers/{EL_READABLE_ZSTRING}.has_between"
		local
			word_intervals: EL_SPLIT_INTERVALS; line: ZSTRING
			i, start_index, lower, upper: INTEGER; uc: CHARACTER_32
		do
			across Text.lines_32 as lines loop
				line := lines.item
				create word_intervals.make (line, ' ')
				if attached word_intervals as word then
					from word.start until word.after loop
						lower := word.item_lower; upper := word.item_upper
						uc := line [lower + (upper - lower + 1) // 2]
						start_index := (lower - 10).max (1)
						assert ("has middle character", line.has_between (uc, start_index, upper))
						assert ("not has bar character", not line.has_between ('|', start_index, upper))
						assert ("not has G-clef character", not line.has_between (Text.G_clef [1], start_index, upper))
						word.forth
					end
				end
			end
		end

	test_has_enclosing
		-- ZSTRING_TEST_SET.test_has_enclosing
		note
			testing: "[
				covers/{EL_READABLE_ZSTRING}.has_enclosing,
				covers/{EL_EXTENDED_READABLE_STRING_I}.has_enclosing
			]"
		do
			across Text.words_32 as word loop
				new_test (word.item).has_enclosing
			end
		end

	test_is_alpha_numeric
		-- ZSTRING_TEST_SET.test_is_alpha_numeric
		note
			testing: "[
				covers/{ZSTRING}.is_alpha_numeric,
				covers/{EL_READABLE_STRING_X_ROUTINES}.is_alpha_numeric,
				covers/{EL_STRING_32_ITERATION_CURSOR}.all_alpha_numeric,
				covers/{EL_CHARACTER_X_ROUTINES}.is_alpha_numeric_area
			]"
		local
			str: ZSTRING; str_is_alpha_numeric, str_32_is_alpha_numeric: BOOLEAN
		do
			across Text.lines_32 as list loop
				if attached list.item as str_32 then
					str := str_32
					across ", :-" as c loop
						str.prune_all (c.item); str_32.prune_all (c.item)
					end
					str_is_alpha_numeric := str.is_alpha_numeric
					str_32_is_alpha_numeric := super_32 (str_32).is_alpha_numeric
					assert ("same result", str_is_alpha_numeric = str_32_is_alpha_numeric)
					inspect list.cursor_index
						when 1 .. 3, 5 then
							assert ("is_alpha_numeric", str_is_alpha_numeric)
					else
						assert ("not is_alpha_numeric", not str_is_alpha_numeric)
					end
				end
			end
		end

	test_is_canonically_spaced
		-- ZSTRING_TEST_SET.test_is_canonically_spaced
		note
			testing: "covers/{ZSTRING}.is_canonically_spaced"
		local
			str, line: ZSTRING; space_index: INTEGER
			canonically_spaced: STRING
		do
			canonically_spaced := "canonically spaced"
			across Text.lines_32 as list loop
				line := list.item
				assert (canonically_spaced, line.is_canonically_spaced)
				space_index := line.index_of (' ', 1)
				if space_index > 0 then
					across << Text.Tab_character, Text.Ogham_space_mark, Text.Non_breaking_space >> as c loop
						line [space_index] := c.item
						assert ("not " + canonically_spaced, not line.is_canonically_spaced)
					end
					line.replace_substring_general (space * 2, space_index, space_index)
					assert ("not " + canonically_spaced, not line.is_canonically_spaced)
				end
			end
		end

	test_order_comparison
		note
			testing: "covers/{EL_READABLE_ZSTRING}.order_comparison"
		local
			list_32: EL_STRING_32_LIST; list: EL_ZSTRING_LIST
			left_32, right_32: STRING_32; left, right: ZSTRING
		do
			list_32 := Text.words_32
			create list.make_from_general (Text.words_32)
			list_32.ascending_sort; list.ascending_sort
			across list_32 as str_32 loop
				assert ("same string", str_32.item ~ list.i_th (str_32.cursor_index).to_string_32)
			end
		end

	test_sort
		note
			testing: "covers/{ZSTRING}.is_less", "covers/{ZSTRING}.order_comparison"
		local
			sorted: EL_SORTABLE_ARRAYED_LIST [ZSTRING]; sorted_32: EL_SORTABLE_ARRAYED_LIST [STRING_32]
			word: ZSTRING
		do
			create sorted.make (20); create sorted_32.make (20)
			sorted.compare_objects; sorted_32.compare_objects
			across Text.lines_32 as line loop
				sorted.wipe_out; sorted_32.wipe_out
				across line.item.split (' ') as w loop
					word := w.item
					sorted.extend (word); sorted_32.extend (w.item)
				end
				sorted.ascending_sort; sorted_32.ascending_sort
				assert ("sorting OK",
					across sorted as l_a all
						l_a.item.same_string (sorted_32.i_th (l_a.cursor_index))
					end
				)
			end
		end

	test_substring_index_list
		-- ZSTRING_TEST_SET.test_substring_index_list
		note
			testing: "covers/{EL_SEARCHABLE_ZSTRING}.substring_index_list"
		local
			test: STRING_TEST; start_index, end_index: INTEGER_32
		do
			across Text.lines_32 as line loop
				test := new_test (line.item)
				inspect line.cursor_index
					when Line_cyrillic then
						end_index := test.s_32.count
						test.set_substrings (end_index - 1, end_index)

					when Line_ascii then
						start_index := test.s_32.substring_index ("at", 1)
						test.set_substrings (start_index, start_index + 1)

					when Line_accented then
						start_index := test.s_32.index_of ('ú', 1)
						test.set_substrings (start_index, start_index)

					when Line_quattro then
						start_index := test.s_32.index_of ('´', 1)
						test.set_substrings (start_index, start_index)
				else
					test.set_substrings (2, 3)
				end
				assert ("substring_index_list OK", test.substring_index_list)
			end
		end

	test_there_exists_split
		note
			testing: "covers/{ZSTRING}.there_exists_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST
		do
			across Text.lines_32 as line_32 loop
				line := line_32.item
				create word_list.make_word_split (line)
				across word_list as word loop
					assert (
						"word is in word_list",
						line.there_exists_split (space, agent (word.item).is_equal)
					)
				end
			end
		end

feature -- Removal tests

	test_remove
		note
			testing: "covers/{ZSTRING}.remove"
		local
			test: STRING_TEST; i: INTEGER
		do
			create test.make_empty (Current)
			across Text.words_32 as word loop
				from i := 1 until i > word.item.count loop
					test.set (word.item)
					test.zs.remove (i); test.s_32.remove (i)
					assert ("remove OK", test.is_same)
					i := i + 1
				end
			end
		end

feature -- Access tests

	test_hash_code
		-- ZSTRING_TEST_SET.test_hash_code
		local
			substring_line_set, line_set: EL_HASH_SET [ZSTRING]
			substring_count, old_count: INTEGER; line, line_substring: ZSTRING
		do
			create substring_line_set.make_equal (10)
			create line_set.make_equal (10)
			across << 1, 2, 3, 4 >> as fifth loop
				line := Text.cyrillic_line_32
				line_set.put (line)
				substring_count := (line.count * fifth.item / 5).rounded
				line_substring := line.substring (1, substring_count)
				substring_line_set.put (line_substring)
				old_count := line.count
				line.set_count (substring_count)
				assert_same_string (Void, line.twin, line_substring)

				assert ("found half line", substring_line_set.has (line))
				line.set_count (old_count)
				assert ("found line", line_set.has (line))
			end
		end

	test_index_of
		note
			testing:	"covers/{ZSTRING}.index_of"
		local
			test: STRING_TEST; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line.item)
				across Text.character_set as set loop
					uc := set.item
					across << 1, test.s_32.count // 2 >> as value loop
						i := value.item
						assert ("index_of OK", test.zs.index_of (uc, i) = test.s_32.index_of (uc, i))
					end
				end
			end
		end

	test_last_index_of
		note
			testing:	"covers/{ZSTRING}.last_index_of"
		local
			test: STRING_TEST; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line.item)
				across Text.character_set as set loop
					uc := set.item
					across << test.s_32.count, test.s_32.count // 2 >> as value loop
						i := value.item
						assert ("last_index_of OK", test.zs.last_index_of (uc, i) = test.s_32.last_index_of (uc, i))
					end
				end
			end
		end

	test_new_cursor
		-- ZSTRING_TEST_SET.test_new_cursor
		note
			testing:	"[
				covers/{EL_READABLE_ZSTRING}.new_cursor,
				covers/{EL_ZSTRING_ITERATION_CURSOR}.item
			]"
		local
			test: STRING_TEST
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line.item)
				across test.zs as c loop
					assert ("same character", c.item = test.s_32 [c.cursor_index])
				end
			end
		end

	test_occurrences
		note
			testing:	"covers/{ZSTRING}.occurrences"
		local
			test: STRING_TEST; uc: CHARACTER_32
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line.item)
				across Text.character_set as set loop
					uc := set.item
				end
				assert ("occurrences OK", test.zs.occurrences (uc) ~ test.s_32.occurrences (uc))
			end
		end

	test_substring_index
		-- ZSTRING_TEST_SET.test_substring_index
		note
			testing: "[
				covers/{EL_SEARCHABLE_ZSTRING}.substring, covers/{EL_SEARCHABLE_ZSTRING}.substring_index
			]"
		local
			test: STRING_TEST; start_index, end_index, from_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "substring_index OK"
			across Text.lines_32 as line loop
				test := new_test (line.item)
				across test.all_word_interval_permutations as permutation loop
					if attached permutation.item as list then
						from list.start until list.after loop
							start_index := list.item_lower; end_index := list.item_upper
							from_index := (start_index - 5).max (1)
							test.set_substrings (start_index, end_index)
							assert (assertion_ok, test.substring_index (from_index))
							list.forth
						end
					end
				end
			end
		end

	test_substring_index_in_bounds
		-- ZSTRING_TEST_SET.test_substring_index_in_bounds
		note
			testing: "[
				covers/{EL_SEARCHABLE_ZSTRING}.substring_index_in_bounds,
				covers/{EL_ZSTRING_SEARCHER}.initialize_z_code_deltas_for_type,
				covers/{EL_ZSTRING_SEARCHER}.substring_index_with_z_code_pattern
			]"
		local
			test: STRING_TEST; start_index, end_index, bound_start_pos, bound_end_pos: INTEGER
			boundary_intervals: EL_SPLIT_INTERVALS; str_32: STRING_32; str: ZSTRING
			assertion_ok: STRING
		do
			assertion_ok := "substring_index_in_bounds OK"
			str_32 := Text.Mixed_text; str := str_32

			create boundary_intervals.make (str_32, '%N')

			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line.item)
				bound_start_pos := boundary_intervals.i_th_lower (line.cursor_index)
				bound_end_pos := boundary_intervals.i_th_upper (line.cursor_index)

				across test.all_word_interval_permutations as permutation loop
					if attached permutation.item as list then
						from list.start until list.after loop
							start_index := list.item_lower; end_index := list.item_upper
							test.set_substrings (start_index, end_index)
							assert (assertion_ok, test.substring_index_in_bounds (str_32, str, bound_start_pos, bound_end_pos))
							list.forth
						end
					end
				end
			end
		end

	test_unicode_index_of
		-- ZSTRING_TEST_SET.test_unicode_index_of
		note
			testing: "covers/{ZSTRING}.index_of"
		local
			test: STRING_TEST
		do
			test := new_test (Text.Mixed_text)
			across Text.Character_set as c loop
				assert ("same index", test.zs.index_of (c.item, 1) = test.s_32.index_of (c.item, 1))
			end
		end

feature -- Duplication tests

	test_substitute_tuple
		-- ZSTRING_TEST_SET.test_substitute_tuple
		note
			testing:	"[
				covers/{ZSTRING}.append_substring,
				covers/{ZSTRING}.substitute_tuple,
				covers/{EL_WRITABLE}.write_any
			]"
		local
			str_32, template_32: STRING_32; l_word: READABLE_STRING_GENERAL; str, substituted, template: ZSTRING
			tuple: TUPLE; i, index: INTEGER
		do
			across Text.lines_32 as line loop
				str_32 := line.item
				if line.cursor_index = 1 then
					-- Test escaping the substitution marker
					str_32.replace_substring_all ({STRING_32} "воду", Escaped_substitution_marker)
				end
				template_32 := str_32.twin
				tuple := Text.Substituted_words [line.cursor_index]
				index := 0
				from i := 1 until i > tuple.count loop
					inspect tuple.item_code (i)
						when {TUPLE}.Character_code then
							create {STRING} l_word.make_filled (tuple.character_item (i), 1)
						when {TUPLE}.Character_32_code then
							create {STRING_32} l_word.make_filled (tuple.character_32_item (i), 1)

						when {TUPLE}.Reference_code then
							if  attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as word then
								l_word := word
							end
					else
						l_word := tuple.item (i).out
					end
					index := template_32.substring_index (l_word, 1)
					template_32.replace_substring ({STRING_32} "%S", index, index + l_word.count - 1)
					i := i + 1
				end
				str := template_32
				substituted := str.substituted_tuple (tuple)
				if line.cursor_index = 1 then
					index := substituted.index_of ('%S', 1)
					substituted.replace_substring_general (Escaped_substitution_marker, index, index)
				end
				assert_same_string ("substitute_tuple OK", substituted, str_32)
			end
			template := "type: %S"
			assert_same_string ("type inserted", template #$ [{STRING_8}], "type: STRING_8")
		end

	test_substring
		-- ZSTRING_TEST_SET.test_substring
		note
			testing: "[
				covers/{ZSTRING}.slice,
				covers/{ZSTRING}.substring,
				covers/{ZSTRING}.substring_between,
				covers/{ZSTRING}.substring_end,
			]"
		local
			test: STRING_TEST; start_index, end_index: INTEGER
			assertion_ok: STRING; str, padded_middle_word: ZSTRING; str_list: EL_ZSTRING_LIST
		do
			assertion_ok := "substring OK"
			across Text.lines_32 as line loop
				test := new_test (line.item)
				across test.all_word_interval_permutations as permutation loop
					if attached permutation.item as list then
						from list.start until list.after loop
							start_index := list.item_lower; end_index := list.item_upper
							test.set_substrings (start_index, end_index)
							assert (assertion_OK, test.same_substring (start_index, end_index))
							list.forth
						end
					end
				end
				across 0 |..| 7 as n loop
					assert (assertion_ok, test.same_substring (1, n.item))
				end
			-- substring_between
				create str_list.make_split (test.zs, ' ')
				padded_middle_word := str_list [2].enclosed (' ', ' ')
				assert_same_string (Void, test.zs.substring_between (str_list [1], str_list [3], 1), padded_middle_word)
				assert_same_string (Void, test.zs.substring_between (str_list [1], space * 1, 1), Empty_string)
			-- substring_end
				start_index := test.s_32.count - 2; end_index := test.s_32.count
				if attached test.s_32.substring (start_index, end_index) as last_three then
					assert_same_string (Void, test.zs.substring_end (start_index), last_three)
					assert_same_string (Void, test.zs.slice (-3, -1), last_three)
				end
			end
		end

	test_substring_to
		note
			testing: "covers/{ZSTRING}.substring_to"
		local
			line, full_text: ZSTRING
			start_index: INTEGER
		do
			full_text := Text.Mixed_text
			start_index := 1
			across Text.lines_32 as list loop
				line := list.item
				assert ("same string", full_text.substring_to_from ('%N', $start_index) ~ line)
			end
			assert ("valid start_index", start_index = full_text.count + 1)
		end

	test_substring_to_reversed
		note
			testing: "covers/{ZSTRING}.substring_to_reversed"
		local
			line, full_text: ZSTRING
			start_end_index: INTEGER
		do
			full_text := Text.Mixed_text
			start_end_index := full_text.count
			across Text.lines_32.new_cursor.reversed as list loop
				line := list.item
				assert ("same string", full_text.substring_to_reversed_from ('%N', $start_end_index) ~ line)
			end
			assert ("valid start_end_index", start_end_index = 0)
		end

end