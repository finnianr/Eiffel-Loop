note
	description: "Testing class ${EL_TRANSFORMABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-11 10:43:37 GMT (Thursday 11th April 2024)"
	revision: "5"

class
	ZSTRING_TRANSFORMABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	STRING_HANDLER undefine default_create end

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_TEST_TEXT

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
				["prune_trailing",		  agent test_prune_trailing],
				["remove_head",			  agent test_remove_head],
				["remove_tail",			  agent test_remove_tail],
				["replace_character",	  agent test_replace_character],
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
			do_pruning_test ({STRING_TEST_FIELDS}.Left_adjust)
			do_pruning_test ({STRING_TEST_FIELDS}.Right_adjust)
			do_pruning_test ({STRING_TEST_FIELDS}.Both_adjust)
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
			across Text.words as word loop
				lower := word.item.as_lower
				upper := lower.as_upper
				change_case (lower, upper)
			end
			change_case (Text.Lower_case_characters, Text.Upper_case_characters)

			across Text.lines as line until line.cursor_index > 2 loop
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
		-- EL_TRANSFORMABLE_ZSTRING.test_enclose
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.enclose,
				covers/{EL_TRANSFORMABLE_ZSTRING}.quote
			]"
		local
			test: STRING_TEST
		do
			create test
			across Text.words as word loop
				test.set (word.item)
				test.s_32.prepend_character ('"'); test.s_32.append_character ('"')
				test.zs.quote (2)
				assert ("enclose OK", test.is_same)
			end
		end

	test_fill_character
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.fill_character"
		local
			test: STRING_TEST
		do
			across 1 |..| 2 as index loop
				create test.make_filled (Text.russian [index.item], 3)
				assert ("same string", test.is_same)
			end
		end

	test_mirror
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.mirror,
				covers/{EL_CONVERTABLE_ZSTRING}.mirrored
			]"
		local
			test: STRING_TEST
		do
			create test
			across Text.words as word loop
				test.set (word.item)
				assert_same_string ("mirror OK", test.zs.mirrored, test.s_32.mirrored)
			end
		end

	test_prune_all
		local
			test: STRING_TEST; uc: CHARACTER_32
		do
			create test
			across Text.character_set as set loop
				uc := set.item
				across Text.lines as line loop
					test.set (line.item)
					test.zs.prune_all (uc); test.s_32.prune_all (uc)
					assert ("prune_all OK", test.is_same)
				end
			end
			across Text.words as word loop
				test.set (word.item)
				from until test.s_32.is_empty loop
					uc := test.s_32 [1]
					test.s_32.prune_all (uc); test.zs.prune_all (uc)
					assert ("prune_all OK", test.is_same)
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
			russian := Text.russian
			russian.prune_all_leading ('%N') -- tests `keep_tail (count)'

			do_pruning_test ({STRING_TEST_FIELDS}.Prune_leading)
		end

	test_prune_trailing
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.prune_all_trailing"
		do
			do_pruning_test ({STRING_TEST_FIELDS}.Prune_trailing)
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
			test := Text.russian_and_english.twin
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
			test := Text.russian_and_english.twin
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
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.replace_character"
		local
			test: STRING_TEST; uc_new, uc_old: CHARACTER_32
			s: EL_STRING_32_ROUTINES
		do
			across Text.russian as uc loop
				test := Text.russian
				if not uc.is_last then
					uc_old := uc.item
					uc_new := test.s_32 [uc.cursor_index + 1]
				end
				s.replace_character (test.s_32, uc_old, uc_new)
				test.zs.replace_character (uc_old, uc_new)
				assert ("replace_character OK", test.is_same)
			end
		end

	test_replace_substring
		note
			testing:	"covers/{EL_TRANSFORMABLE_ZSTRING}.replace_substring"
		local
			word_list_32: EL_STRING_32_LIST; index, start_index, end_index: INTEGER
			space_intervals: EL_OCCURRENCE_INTERVALS; test, word_pair: STRING_TEST
			line_list: like Text.lines
		do
			create test; create word_pair
			create space_intervals.make_empty
			create word_list_32.make (50)
			line_list := Text.lines
			across line_list as line loop
				if line.is_first or line.is_last then
					across line.item.split (' ') as list loop
						word_list_32.extend (list.item)
					end
				end
			end
			across word_list_32 as list loop
				word_pair.set (list.item)
				across Text.lines as line loop
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
			word, word_A, first_word: STRING_32; i: INTEGER; s32: EL_STRING_32_ROUTINES
		do
			create word_list.make (20)
			create test
			across Text.lines as line loop
				first_word := s32.substring_to (line.item, ' ')
				word_A := "A"
				test.set (line.item)
				across << word_A, first_word + first_word >> as list loop
					word := list.item
					test.set_old_new (first_word, word)
					assert ("replace_substring_all OK", test.replace_substring_all)
				end
			end
			from i := 1 until i > 4 loop
				across Text.lines as line loop
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
		note
			testing:	"[
				covers/{EL_TRANSFORMABLE_ZSTRING}.to_canonically_spaced,
				covers/{EL_READABLE_ZSTRING}.is_canonically_spaced
			]"
		local
			canonical, line, not_canonical_line: ZSTRING
			count: INTEGER
		do
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
			across Text.lines as list loop
				line := list.item
				create not_canonical_line.make (line.count * 2)
				count := 0
				across line.split (' ') as split loop
					if count > 0 then
					-- insert bigger and bigger space strings
						not_canonical_line.append (Space * count)
					end
					not_canonical_line.append (split.item)
					count := count + 1
				end
				not_canonical_line.to_canonically_spaced
				assert_same_string ("same as canonical", line, not_canonical_line)
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
				across Text.lines as list loop
					if attached list.item as line then
						across line.split (' ') as split loop
							if attached split.item as word and then attached new_characters_set (word) as old_set then
								create new_set.make_filled (c.item, old_set.count)
								create test.make (line.twin)
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
			create test
			across Text.words as word loop
				test.set (word.item)
				across << Text.Tab_character, Text.Ogham_space_mark >> as c loop
					across 1 |..| 2 as n loop
						inspect type
							when {STRING_TEST_FIELDS}.Right_adjust, {STRING_TEST_FIELDS}.Prune_trailing then
								test.s_32.append_character (c.item)
								op_name := "append_character"
						else
							test.s_32.prepend_character (c.item)
							op_name := "prepend_character"
						end
						test.set_z_from_uc
					end
					assert (op_name + " OK", test.is_same)

					test.prune (type, c.item)

					assert (test.prune_type_name (type) + " OK", test.is_same)
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