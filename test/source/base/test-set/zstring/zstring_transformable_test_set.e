note
	description: "${EL_TRANSFORMABLE_ZSTRING} test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 13:59:56 GMT (Saturday 3rd May 2025)"
	revision: "17"

class
	ZSTRING_TRANSFORMABLE_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

	EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["adjustments",			  agent test_adjustments],
				["case_changing",			  agent test_case_changing],
				["enclose",					  agent test_enclose],
				["fill_character",		  agent test_fill_character],
				["mirror",					  agent test_mirror],
				["prune_all",				  agent test_prune_all],
				["prune_leading",			  agent test_prune_leading],
				["prune_set_members",	  agent test_prune_set_members],
				["prune_trailing",		  agent test_prune_trailing],
				["remove_head",			  agent test_remove_head],
				["remove_tail",			  agent test_remove_tail],
				["replace_character",	  agent test_replace_character],
				["replace_set_members",	  agent test_replace_set_members],
				["replace_substring",	  agent test_replace_substring],
				["replace_substring_all", agent test_replace_substring_all],
				["to_canonically_spaced", agent test_to_canonically_spaced],
				["translate",				  agent test_translate]
			>>)
		end

feature -- Tests

	test_adjustments
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.left_adjust"
		do
			do_pruning_test ({STRING_TEST_BASE}.Left_adjust)
			do_pruning_test ({STRING_TEST_BASE}.Right_adjust)
			do_pruning_test ({STRING_TEST_BASE}.Both_adjust)
		end

	test_case_changing
		-- ZSTRING_TEST_SET.test_case_changing
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.to_lower,
				covers/{EL_TRANSFORMABLE_ZSTRING}.to_upper,
				covers/{EL_TRANSFORMABLE_ZSTRING}.to_proper
			]"
		local
			lower, upper, str_32: STRING_32; str: ZSTRING
			word_intervals: EL_SPLIT_INTERVALS
		do
			across Text.words_32 as word loop
				lower := word.item.as_lower
				upper := lower.as_upper
				change_case (lower, upper)
			end
			change_case (Lower_case_characters, Upper_case_characters)

			across Text.lines_32 as line until line.cursor_index > 2 loop
				str_32 := line.item; str := str_32
				create word_intervals.make (str_32, ' ')
				if attached word_intervals as word then
					from word.start until word.after loop
						str_32 [word.item_lower] := str_32 [word.item_lower].upper
						word.forth
					end
				end
				str.to_proper
				assert_same_string (Void, str_32, str)
			end
		end

	test_enclose
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_enclose
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.enclose,
				covers/{EL_TRANSFORMABLE_ZSTRING}.quoted,
				covers/{EL_EXTENDED_STRING_GENERAL}.quoted
			]"
		local
			test: STRING_TEST
		do
			create test.make_empty (Current)
			across Text.words_32 as word loop
				test.set (word.item)
				if word.cursor_index = Line_latin_1 then
					super_32 (test.s_32).replace_character ('=', '"') -- "Latin-1: ¼ + ¾ " 1"
				end
			-- 3 is appropriate quotes type
				assert_same_string ("enclose OK", test.zs.quoted (3), super_32 (test.s_32).quoted (3))
			end
		end

	test_fill_character
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.fill_character"
		local
			test: STRING_TEST
		do
			create test.make_empty (Current)
			across 1 |..| 2 as index loop
				test.set_filled (Text.cyrillic_line_32 [index.item], 3)
				assert ("same string", test.is_same)
			end
		end

	test_mirror
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_mirror
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.mirror,
				covers/{EL_CONVERTABLE_ZSTRING}.mirrored
			]"
		local
			test: STRING_TEST
		do
			create test.make_empty (Current)
			across Text.words_32 as word loop
				test.set (word.item)
				assert_same_string ("mirror OK", test.zs.mirrored, test.s_32.mirrored)
			end
		end

	test_prune_all
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_prune_all
		local
			test: STRING_TEST
		do
			across Text.lines_32 as line loop
				create test.make (Current, line.item)
				across Text.character_set as set loop
					test.prune_all (set.item)
				end
			end
		end

	test_prune_leading
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.prune_all_leading,
				covers/{EL_TRANSFORMABLE_ZSTRING}.keep_tail
			]"
		local
			russian: ZSTRING
		do
			russian := Text.cyrillic_line_32
			russian.prune_all_leading ('%N') -- tests `keep_tail (count)'

			do_pruning_test ({STRING_TEST_BASE}.Prune_leading)
		end

	test_prune_set_members
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_prune_set_members
		note
			testing: "[
				covers/{EL_ZSTRING}.prune_set_members,
				covers/{EL_EXTENDED_STRING_GENERAL}.prune_set_members
			]"
		do
			do_set_members_test ('p')
		end

	test_prune_trailing
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.prune_all_trailing"
		do
			do_pruning_test ({STRING_TEST_BASE}.Prune_trailing)
		end

	test_remove_head
		note
			testing: "[
				covers/{EL_TRANSFORMABLE_ZSTRING}.remove_head,
				covers/{EL_TRANSFORMABLE_ZSTRING}.keep_tail
			]"
		local
			test: STRING_TEST; pos: INTEGER
		do
			test := new_test (Text.Mixed_text.twin)
			from until test.s_32.is_empty loop
				pos := test.s_32.index_of (' ', test.s_32.count)
				if pos > 0 then
					test.s_32.remove_head (pos); test.zs.remove_head (pos)
				else
					test.s_32.remove_head (test.s_32.count) test.zs.remove_head (test.zs.count)
				end
				assert ("remove_head OK", test.is_same)
			end
		end

	test_remove_tail
		note
			testing: "[
				covers/{EL_TRANSFORMABLE_ZSTRING}.remove_tail,
				covers/{EL_TRANSFORMABLE_ZSTRING}.keep_head
			]"
		local
			test: STRING_TEST; pos: INTEGER
		do
			test := new_test (Text.Mixed_text.twin)
			from until test.s_32.is_empty loop
				pos := test.s_32.last_index_of (' ', test.s_32.count)
				if pos > 0 then
					test.s_32.remove_tail (pos); test.zs.remove_tail (pos)
				else
					test.s_32.remove_tail (test.s_32.count) test.zs.remove_tail (test.zs.count)
				end
				assert ("remove_tail OK", test.is_same)
			end
		end

	test_replace_character
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_replace_character
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.replace_character"
		local
			test: STRING_TEST; uc_new, uc_old: CHARACTER_32; sg: EL_STRING_GENERAL_ROUTINES
		do
			across Text.cyrillic_line_32 as uc loop
				test := new_test (Text.cyrillic_line_32)
				if not uc.is_last then
					uc_old := uc.item
					uc_new := test.s_32 [uc.cursor_index + 1]
				end
				sg.super_32 (test.s_32).replace_character (uc_old, uc_new)
				test.zs.replace_character (uc_old, uc_new)
				assert ("replace_character OK", test.is_same)
			end
		end

	test_replace_set_members
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_replace_set_members
		note
			testing: "[
				covers/{EL_TRANSFORMABLE_ZSTRING}.replace_set_members,
				covers/{EL_EXTENDED_STRING_GENERAL}.replace_set_members
			]"
		do
			do_set_members_test ('r')
		end

	test_replace_substring
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.replace_substring"
		local
			word_list_32: EL_STRING_32_LIST; index, start_index, end_index: INTEGER
			space_intervals: EL_OCCURRENCE_INTERVALS; test, word_pair: STRING_TEST
			line_list: like Text.lines_32
		do
			create test.make_empty (Current) ; create word_pair.make_empty (Current)
			create space_intervals.make_empty
			create word_list_32.make (50)
			line_list := Text.lines_32
			across line_list as line loop
				if line.is_first or line.is_last then
					across line.item.split (' ') as list loop
						word_list_32.extend (list.item)
					end
				end
			end
			across word_list_32 as list loop
				word_pair.set (list.item)
				across Text.lines_32 as line loop
					test.set (line.item)
					space_intervals.fill (test.s_32, ' ', 0)
					start_index := space_intervals.first_lower + 1
					end_index := space_intervals.i_th_lower (2) - 1
					test.s_32.replace_substring (word_pair.s_32, start_index, end_index)
					test.zs.replace_substring (word_pair.zs, start_index, end_index)
					assert ("same characters", test.is_same)
				end
			end
		end

	test_replace_substring_all
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_replace_substring_all
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.replace_substring_all,
				covers/{EL_SEARCHABLE_ZSTRING}.substring_index_list
			]"
		local
			test: STRING_TEST; word_list, s_32_words: EL_STRING_32_LIST
			word, word_A, first_word: STRING_32; i: INTEGER
		do
			create word_list.make (20)
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				first_word := super_32 (line.item).substring_to (' ')
				word_A := "A"
				test.set (line.item)
				across << word_A, first_word + first_word >> as list loop
					word := list.item
					test.set_old_new (first_word, word)
					assert ("replace_substring_all OK", test.replace_substring_all)
				end
			end
			from i := 1 until i > 4 loop
				across Text.lines_32 as line loop
					test.set (line.item.as_lower)

					word_list.wipe_out
					-- Replace each word with A, B, C letters
					create s_32_words.make_word_split (test.s_32)
					across s_32_words as list loop
						word := list.item
						word.to_lower
						if not list.is_last then
							inspect i
								when 2 then
--									word plus a space
									word.append_character (' ')
								when 3 then
--									2 words
									word.append (s_32_words.i_th (list.cursor_index + 1).as_lower)
								when 4 then
--									2 split words
									word.append (s_32_words.i_th (list.cursor_index + 1).as_lower)
									word.remove_head (list.item.count // 2)
									word.remove_tail (s_32_words.i_th (list.cursor_index + 1).count // 2)
							else
							end
						end
						if test.zs.substring_index_list_general (word, False).count = 1 then
							test.set_old_new (word, ('A' + word_list.count).out)
							word_list.extend (word)
							assert ("replace_substring_all OK", test.replace_substring_all)
						end
					end
					-- Reverse replacements
					across word_list as list loop
						word := list.item
						test.set_old_new (('A' + list.cursor_index - 1).out, word)
						assert ("replace_substring_all OK", test.replace_substring_all)
					end
					assert ("line restored", test.s_32 ~ line.item.as_lower)
				end
				i := i + 1
			end
		end

	test_to_canonically_spaced
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_to_canonically_spaced
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.to_canonically_spaced,
				covers/{EL_READABLE_ZSTRING}.is_canonically_spaced,
				covers/{EL_EXTENDED_STRING_GENERAL}.to_canonically_spaced,
				covers/{EL_EXTENDED_STRING_GENERAL}.is_canonically_spaced
			]"
		local
			canonical, line, not_canonical_line, white_space: ZSTRING; str_32: STRING_32
			count: INTEGER; tab_space: SPECIAL [CHARACTER_32]; sg: EL_STRING_GENERAL_ROUTINES
		do
			create tab_space.make_filled ('%T', 4)
			tab_space [1] := ' '
			tab_space [2] := Text.Ogham_space_mark
			tab_space [3] := Text.Non_breaking_space
			create white_space.make_empty

		-- Basic test
			canonical := "2023 Oct 8"
			not_canonical_line := canonical.twin
			not_canonical_line.insert_character (' ', canonical.count - 1)

			if attached not_canonical_line as str then
				if str.is_canonically_spaced then
					failed ("is not canonically spaced")
				else
					str.to_canonically_spaced
					assert_same_string (Void, canonical, str)
				end
			end

		-- Rigorous test
			across Text.lines_32 as list loop
				line := list.item
				assert ("canonically spaced", line.is_canonically_spaced)
				assert ("STRING_32 canonically spaced", sg.super_32 (line.to_string_32).is_canonically_spaced)

				create not_canonical_line.make (line.count * 2)
				count := 0
				white_space.wipe_out
				across line.split (' ') as split loop
					if count > 0 then
					-- insert bigger and bigger space strings
						white_space.extend (tab_space [count \\ tab_space.count])
						not_canonical_line.append (white_space)
					end
					not_canonical_line.append (split.item)
					count := count + 1
				end
				str_32 := not_canonical_line.to_string_32
				not_canonical_line.to_canonically_spaced
				assert_same_string ("same as canonical", line, not_canonical_line)

				sg.super_32 (str_32).to_canonically_spaced
				assert ("same string", not_canonical_line.to_string_32 ~ str_32)
			end
		end

	test_translate
		-- ZSTRING_TRANSFORMABLE_TEST_SET.test_translate
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.translate"
		local
			test: STRING_TEST; new_set: STRING_32
		do
			across << space.item, Text.Ogham_space_mark, ('%U').to_character_32 >> as c loop
				across Text.lines_32 as list loop
					if attached list.item as line then
						across line.split (' ') as split loop
							if attached split.item as word and then attached new_characters_set (word) as old_set then
								create new_set.make_filled (c.item, old_set.count)
								test := new_test (line.twin)
								test.set_old_new (old_set, new_set)
								assert ("translate OK", test.translate (c.item.code = 0))
							end
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	change_case (lower_32, upper_32: STRING_32)
		local
			lower, upper: ZSTRING
		do
			lower := lower_32; upper :=  upper_32
			assert_same_string ("to_upper OK", lower.as_upper, upper_32)
			assert_same_string ("to_lower OK", upper.as_lower, lower_32)
		end

	do_pruning_test (type: INTEGER)
		local
			test: STRING_TEST; op_name: STRING
		do
			create test.make_empty (Current)
			across Text.words_32 as word loop
				test.set (word.item)
				across << Text.Tab_character, Text.Ogham_space_mark, Text.Non_breaking_space >> as c loop
					across 1 |..| 2 as n loop
						inspect type
							when {STRING_TEST_BASE}.Right_adjust, {STRING_TEST_BASE}.Prune_trailing then
								test.s_32.append_character (c.item)
								op_name := "append_character"
						else
							test.s_32.prepend_character (c.item)
							op_name := "prepend_character"
						end
						test.set_zs_from_s_32
					end
					assert (op_name + " OK", test.is_same)

					test.prune (type, c.item)

					assert (test.prune_type_name (type) + " OK", test.is_same)
				end
			end
		end

	do_set_members_test (type: CHARACTER)
		local
			test: STRING_TEST; hash_set: EL_HASH_SET [CHARACTER_32]; set_8: EL_HASH_SET [CHARACTER_8]
			word: STRING_32
		do
			across Text.lines_32 as line loop
				create test.make (Current, line.item)
				if attached line.item.split (' ') as word_list then
					inspect line.cursor_index
						when Line_quattro then
							word := word_list [4] -- "´L´Estate`"
						when Line_euro then
							word := word_list [2]
					else
						word := word_list [1]
					end
				end
				create hash_set.make_from (word, True)
				create set_8.make (word.count)
				across word as c loop
					if attached c.item as uc and then uc.is_character_8 then
						set_8.put (uc.to_character_8)
					end
				end

				across Text.character_set as set loop
					inspect type
						when 'p' then
							test.prune_set_members (hash_set, set_8)
						when 'r' then
							test.replace_set_members (hash_set, set_8)
					end
				end
			end
		end

	new_characters_set (str: STRING_32): STRING_32
		do
			create Result.make (str.count)
			across str as c loop
				if not Result.has (c.item) then
					Result.extend (c.item)
				end
			end
		end

end