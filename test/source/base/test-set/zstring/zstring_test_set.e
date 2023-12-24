note
	description: "Tests for class [$source EL_ZSTRING]"
	notes: "[
		Don't forget to also run the test with the latin-15 codec. See `on_prepare'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:08:54 GMT (Sunday 24th December 2023)"
	revision: "115"

class
	ZSTRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_ZSTRING_CONSTANTS

	EL_STRING_32_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

	EL_SHARED_ENCODINGS

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["fill_with_z_code",					agent test_fill_with_z_code],
				["as_expanded",						agent test_as_expanded],
				["mirror",								agent test_mirror],
				["split",								agent test_split],
				["substring_split",					agent test_substring_split],
				["to_general",							agent test_to_general],
				["to_string_32",						agent test_to_string_32],
				["append",								agent test_append],
				["append_encoded",					agent test_append_encoded],
				["append_replaced",					agent test_append_replaced],
				["append_string_general",			agent test_append_string_general],
				["append_substring_general",		agent test_append_substring_general],
				["append_to_string_32",				agent test_append_to_string_32],
				["append_unicode",					agent test_append_unicode],
				["append_utf_8",						agent test_append_utf_8],
				["prepend",								agent test_prepend],
				["prepend_string_general",			agent test_prepend_string_general],
				["prepend_substring",				agent test_prepend_substring],
				["adjustments",						agent test_adjustments],
				["prune_all",							agent test_prune_all],
				["prune_leading",						agent test_prune_leading],
				["prune_trailing",					agent test_prune_trailing],
				["remove_substring",					agent test_remove_substring],
				["case_changing",						agent test_case_changing],
				["enclose",								agent test_enclose],
				["fill_character",					agent test_fill_character],
				["insert_character",					agent test_insert_character],
				["insert_remove",						agent test_insert_remove],
				["joined",								agent test_joined],
				["put_unicode",						agent test_put_unicode],
				["replace_character",				agent test_replace_character],
				["replace_substring",				agent test_replace_substring],
				["replace_substring_all",			agent test_replace_substring_all],
				["to_canonically_spaced",			agent test_to_canonically_spaced],
				["to_utf_8",							agent test_to_utf_8],
				["translate",							agent test_translate],
				["ends_with",							agent test_ends_with],
				["fill_alpha_numeric_intervals",	agent test_fill_alpha_numeric_intervals],
				["for_all_split",						agent test_for_all_split],
				["has",									agent test_has],
				["has_between",						agent test_has_between],
				["is_canonically_spaced",			agent test_is_canonically_spaced],
				["order_comparison",					agent test_order_comparison],
				["same_caseless_characters",		agent test_same_caseless_characters],
				["same_characters",					agent test_same_characters],
				["sort",									agent test_sort],
				["starts_with",						agent test_starts_with],
				["there_exists_split",				agent test_there_exists_split],
				["remove",								agent test_remove],
				["remove_head",						agent test_remove_head],
				["remove_tail",						agent test_remove_tail],
				["index_of",							agent test_index_of],
				["last_index_of",						agent test_last_index_of],
				["new_cursor",							agent test_new_cursor],
				["occurrences",						agent test_occurrences],
				["substring_index",					agent test_substring_index],
				["substring_index_in_bounds",		agent test_substring_index_in_bounds],
				["unicode_index_of",					agent test_unicode_index_of],
				["substring",							agent test_substring],
				["substring_to",						agent test_substring_to],
				["substring_to_reversed",			agent test_substring_to_reversed],
				["substitute_tuple",					agent test_substitute_tuple]
			>>)
		end

feature -- General tests

	test_fill_with_z_code
		-- ZSTRING_TEST_SET.test_fill_with_z_code
		note
			testing:	"[
				covers/{EL_READABLE_ZSTRING}.make_from_zcode_area,
				covers/{EL_WRITEABLE_ZSTRING}.fill_with_z_code
			]"
		local
			zstr, zstr_2: ZSTRING; str_32: STRING_32; z_code_area: SPECIAL [NATURAL]
			s32: EL_STRING_32_ROUTINES
		do
			create str_32.make_empty
			across Text.words as list loop
				zstr := list.item
				zstr.fill_with_z_code (str_32)
				create zstr_2.make_from_zcode_area (s32.to_code_array (str_32))
				assert_same_string (Void, zstr, zstr_2)
			end
		end

feature -- Conversion tests

	test_as_expanded
		-- ZSTRING_TEST_SET.test_as_expanded
		note
			testing:	"[
				covers/{ZSTRING}.mirror,
				covers/{ZSTRING}.mirrored
			]"
		local
			test: STRING_TEST; i: INTEGER
			z_code_string: STRING_32; general: READABLE_STRING_GENERAL
		do
			create test
		 	across Text.lines as line loop
		 		test.set (line.item)
		 		z_code_string := test.zs.shared_z_code_pattern (1)
		 		if z_code_string.count = test.zs.count then
		 			general := test.zs
		 			from i := 1 until i > z_code_string.count loop
		 				assert ("same code", general.code (i) = z_code_string.code (i))
		 				i := i + 1
		 			end
		 		else
		 			failed ("expanded same length")
		 		end
		 	end
		end

	test_mirror
		note
			testing:	"covers/{ZSTRING}.mirror, covers/{ZSTRING}.mirrored"
		local
			test: STRING_TEST
		do
			create test
			across Text.words as word loop
				test.set (word.item)
				assert_same_string ("mirror OK", test.zs.mirrored, test.s_32.mirrored)
			end
		end

	test_split
		note
			testing: "covers/{ZSTRING}.substring", "covers/{ZSTRING}.split", "covers/{ZSTRING}.index_of"
		local
			list: LIST [ZSTRING]; list_32: LIST [STRING_32]
			test: STRING_TEST; i: INTEGER
		do
			create test
			across Text.lines as line loop
				test.set (line.item)
				from i := 1 until i > 3 loop
					list := test.zs.split_list (test.s_32 [i])
					list_32 := test.s_32.split (test.s_32 [i])
					assert ("same count", list.count = list_32.count)
					if list.count = list_32.count then
						assert ("same content", across list as ls all ls.item.same_string (list_32.i_th (ls.cursor_index)) end)
					end
					i := i + 1
				end
			end
		end

	test_substring_split
		note
			testing: "covers/{ZSTRING}.substring_split", "covers/{ZSTRING}.split_intervals",
						"covers/{ZSTRING}.substring_intervals"
		local
			str, delimiter, str_2, l_substring: ZSTRING
		do
			across Text.lines as line loop
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
			str := Text.russian_and_english; delimiter := "Latin"
			across str.substring_split (delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert_same_string ("substring_split OK", str, Text.russian_and_english)
		end

	test_to_general
		-- ZSTRING_TEST_SET.test_to_general
		note
			testing:	"covers/{ZSTRING}.to_general", "covers/{ZSTRING}.make_from_general"
		local
			test: STRING_TEST
		do
			create test
			across Text.lines as line loop
				test.set (line.item)
				assert ("to_general OK", test.to_general)
			end
		end

	test_to_string_32
		-- ZSTRING_TEST_SET.test_to_string_32
		note
			testing:	"covers/{ZSTRING}.to_string_32", "covers/{ZSTRING}.make_from_general"
		local
			test: STRING_TEST
		do
			create test
			across Text.lines as line loop
				test.set (line.item)
				assert ("strings equal", test.is_same)
			end
		end

feature -- Appending tests

	test_append
		do
			test_concatenation ({STRING_TEST_FIELDS}.Append)
		end

	test_append_encoded
		-- ZSTRING_TEST_SET.test_append_encoded
		local
			test: STRING_TEST; encoded: STRING; encoding_id: NATURAL
			encodeable: EL_ENCODEABLE_AS_TEXT; uncovertable_count: INTEGER
			unicode: ENCODING
		do
			create encodeable.make_default
			create test
			unicode := Encodings.Unicode
		 	across Text.lines as line loop
		 		test.set (line.item)
				across Text.all_encodings as encoding loop
					encoding_id := encoding.item
					test.zs.wipe_out
					encodeable.set_encoding (encoding_id)
					unicode.convert_to (encodeable.as_encoding, test.s_32)
					if unicode.last_conversion_lost_data then
						uncovertable_count := uncovertable_count + 1
					else
						encoded := unicode.last_converted_string_8
						test.zs.append_encoded (unicode.last_converted_string_8, encoding_id)
						assert ("same string", test.is_same)
					end
				end
		 	end
		 	assert ("82 not convertable", uncovertable_count = 82)

		 	across Text.lines as line loop
		 		if line.item.is_valid_as_string_8 then
			 		test.set (line.item)
			 		test.zs.wipe_out
			 		test.zs.append_encoded (test.s_32.to_string_8, {EL_ENCODING_TYPE}.Latin_1)
			 		assert ("same strings", test.is_same)
		 		end
		 	end
		end

	test_append_replaced
		note
			testing: "covers/{EL_APPENDABLE_ZSTRING}.append_replaced"
		local
			zstr, line, entity: ZSTRING; str_32, line_32, entity_32: STRING_32
			s: EL_STRING_32_ROUTINES
		do
			entity_32 := "&nbsp;"; entity := entity_32
			create str_32.make_empty
			create zstr.make_empty
			across 1 |..| 2 as n loop
				str_32.wipe_out; zstr.wipe_out
				across Text.lines as list until list.cursor_index > 3 loop
					if n.item = 2 then
						line_32 := s.enclosed (list.item, ' ', ' ')
					else
						line_32 := list.item
					end
					line := line_32; str_32.append (line_32)
					zstr.append_replaced (line, space, entity)
				end
				str_32.replace_substring_all (space.as_string_32 (1), entity_32)
				assert_same_string (Void, str_32, zstr)
			end
		end

	test_append_string_general
		note
			testing: "[
				covers/{ZSTRING}.append_string_general,
				covers/{ZSTRING}.substring
			]"
		local
			test: STRING_TEST; substring_size, start_index, end_index: INTEGER
		do
			across << False, True >> as boolean loop
				if boolean.item then
					create test
				else
					create {IMMUTABLE_STRING_TEST} test
				end

				across << 3, 5, 7 >> as n loop
					substring_size := n.item
					across Text.lines as line loop
						test.set (line.item)
						test.zs.wipe_out
						end_index := 0
						from start_index := 1 until end_index = test.s_32.count loop
							end_index := (start_index + substring_size - 1).min (test.s_32.count)
							test.set_substrings (start_index, end_index)
							assert ("append_string_general OK", test.append_string_general)
							start_index := start_index + substring_size
						end
						assert ("same size strings", test.is_same_size)
					end
				end
			end
		end

	test_append_substring_general
		note
			testing: "covers/{ZSTRING}.append_substring_general", "covers/{ZSTRING}.substring"
		local
			test: STRING_TEST; substring_size, start_index, end_index: INTEGER
		do
			across << False, True >> as boolean loop
				if boolean.item then
					create test
				else
					create {IMMUTABLE_STRING_TEST} test
				end

				across << 3, 5, 7 >> as n loop
					substring_size := n.item
					across Text.lines as line loop
						test.set (line.item)
						test.zs.wipe_out
						end_index := 0
						from start_index := 1 until end_index = test.s_32.count loop
							end_index := (start_index + substring_size - 1).min (test.s_32.count)
							assert ("append_substring_general OK", test.append_substring_general (start_index, end_index))
							start_index := start_index + substring_size
						end
						assert ("same size strings", test.is_same_size)
					end
				end
			end
		end

	test_append_to_string_32
		-- ZSTRING_TEST_SET.test_append_to_string_32
		note
			testing: "[
				covers/{ZSTRING}.append_to_string_8,
				covers/{ZSTRING}.append_to_string_32
			]"
		local
			str_32, word_32: STRING_32; word: ZSTRING
			str_32_str_8, zstr_str_8: STRING_8
		do
			across Text.lines as line_32 loop
				create str_32.make (0)
				create str_32_str_8.make (0)
				create zstr_str_8.make (0)

				across line_32.item.split (' ') as list loop
					word_32 := list.item
					word := word_32
					if list.cursor_index > 1 then
						str_32.append_character (' ')
						str_32_str_8.append_character (' ')
						zstr_str_8.append_character (' ')
					end
					word.append_to_string_32 (str_32)
					if word_32.is_valid_as_string_8 then
						str_32_str_8.append_string_general (word_32)
						word.append_to_string_8 (zstr_str_8)
					end
				end
				assert ("same string", str_32 ~ line_32.item)
				assert ("same appended STRING_8", str_32_str_8 ~ zstr_str_8)
			end
		end

	test_append_unicode
		local
			a: ZSTRING
		do
			create a.make_empty
			across Text.russian_and_english as uc loop
				a.append_unicode (uc.item.natural_32_code)
			end
			assert_same_string ("append_unicode OK", a, Text.russian_and_english)
		end

	test_append_utf_8
		-- ZSTRING_TEST_SET.test_append_utf_8
		local
			utf_8: STRING; conv: EL_UTF_CONVERTER; test: STRING_TEST
		do
			create test
			across Text.lines as line loop
				test.wipe_out
				across conv.string_32_to_utf_8_string_8 (line.item).split (' ') as utf_word loop
					if test.s_32.count > 0 then
						test.append_character (' ')
					end
					test.zs.append_utf_8 (utf_word.item)
					test.s_32.append (conv.utf_8_string_8_to_string_32 (utf_word.item))
					assert ("same string", test.is_same)
				end
			end
		end

feature -- Prepending tests

	test_prepend
		do
			test_concatenation ({STRING_TEST_FIELDS}.Prepend)
		end

	test_prepend_string_general
		note
			testing: "[
				covers/{ZSTRING}.append_string_general,
				covers/{ZSTRING}.substring
			]"
		local
			test: STRING_TEST; substring_size, start_index, end_index: INTEGER
		do
			across << False, True >> as boolean loop
				if boolean.item then
					create test
				else
					create {IMMUTABLE_STRING_TEST} test
				end

				across << 3, 5, 7 >> as n loop
					substring_size := n.item
					across Text.lines as line loop
						test.set (line.item)
						test.zs.wipe_out
						start_index := test.s_32.count
						from end_index := test.s_32.count until start_index = 1 loop
							start_index := (end_index - substring_size + 1).max (1)
							test.set_substrings (start_index, end_index)
							assert ("prepend_string_general OK", test.prepend_string_general)
							end_index := end_index - substring_size
						end
						assert ("same size strings", test.is_same_size)
					end
				end
			end
		end

	test_prepend_substring
		local
			test: STRING_TEST; line: ZSTRING
			word_list: EL_OCCURRENCE_INTERVALS
			start_index, end_index: INTEGER; s: EL_STRING_32_ROUTINES
		do
			across Text.lines as line_32 loop
				line := line_32.item
				create test
				create word_list.make (line_32.item, ' ')
				start_index := 1
				from word_list.start until word_list.after loop
					end_index := word_list.item_lower - 1
					test.s_32.prepend_substring (line_32.item, start_index, end_index)
					test.s_32.prepend_substring (line_32.item, word_list.item_lower, word_list.item_upper)
					test.zs.prepend_substring (line, start_index, end_index)
					test.zs.prepend_substring (line, word_list.item_lower, word_list.item_upper)
					assert ("same string", test.is_same)
					start_index := word_list.item_upper + 1
					word_list.forth
				end
			end
		end

feature -- Removal tests

	test_adjustments
		note
			testing:	"covers/{ZSTRING}.left_adjust"
		do
			do_pruning_test ({STRING_TEST_FIELDS}.Left_adjust)
			do_pruning_test ({STRING_TEST_FIELDS}.Right_adjust)
			do_pruning_test ({STRING_TEST_FIELDS}.Both_adjust)
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
				covers/{ZSTRING}.prune_all_leading,
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
			testing:	"covers/{ZSTRING}.prune_all_trailing"
		do
			do_pruning_test ({STRING_TEST_FIELDS}.Prune_trailing)
		end

	test_remove_substring
		note
			testing: "covers/{ZSTRING}.remove_substring"
		local
			test: STRING_TEST; substring: STRING_32
			l_interval: INTEGER_INTERVAL; i, lower, upper, offset: INTEGER
		do
			create test
			across Text.word_intervals as interval loop
				from offset := 0 until offset > (interval.item.count // 2).max (1) loop
					l_interval := (interval.item.lower + offset) |..| (interval.item.upper + offset)
					if Text.russian_and_english.valid_index (l_interval.lower)
						and then Text.russian_and_english.valid_index (l_interval.upper)
					then
						substring := Text.russian_and_english.substring (l_interval.lower, l_interval.upper) -- Debug
						test.set (Text.russian_and_english.twin)
						test.s_32.remove_substring (l_interval.lower, l_interval.upper)
						test.zs.remove_substring (l_interval.lower, l_interval.upper)
						assert ("remove_substring OK", test.is_same)
					end
					offset := offset + (interval.item.count // 2).max (1)
				end
			end
			across Text.words as word loop
				test.set (word.item)
				test.zs.remove_substring (1, test.zs.count)
				test.s_32.remove_substring (1, test.s_32.count)
				assert ("empty string", test.s_32.is_empty)
				assert ("same strings", test.is_same)
			end
		end

feature -- Element change tests

	test_case_changing
		-- ZSTRING_TEST_SET.test_case_changing
		note
			testing:	"[
				covers/{ZSTRING}.to_lower,
				covers/{ZSTRING}.to_upper,
				covers/{ZSTRING}.to_proper_case
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
		-- ZSTRING_TEST_SET.test_enclose
		note
			testing:	"[
				covers/{ZSTRING}.enclose, covers/{ZSTRING}.quote
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
			testing:	"covers/{ZSTRING}.fill_character"
		local
			test: STRING_TEST
		do
			across 1 |..| 2 as index loop
				create test.make_filled (Text.russian [index.item], 3)
				assert ("same string", test.is_same)
			end
		end

	test_insert_character
		note
			testing:	"covers/{ZSTRING}.insert_character"
		local
			str_32, word_32: STRING_32; word: ZSTRING; uc_1, uc_2: CHARACTER_32
		do
			across Text.words as list loop
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
			create test
			G_clef := Text.G_clef
			across Text.lines as line loop
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
			across Text.lines as list loop
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
			test := Text.russian
			across << true, false >> as test_put_z_code loop
				across Text.russian as c loop
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

	test_replace_character
		note
			testing:	"covers/{ZSTRING}.replace_character"
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
			testing:	"covers/{ZSTRING}.replace_substring"
		local
			test, word_pair: STRING_TEST
			word_list_32: EL_STRING_32_LIST; index, start_index, end_index: INTEGER
			space_intervals: EL_OCCURRENCE_INTERVALS
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
		-- ZSTRING_TEST_SET.test_replace_substring_all
		note
			testing:	"covers/{ZSTRING}.replace_substring_all"
		local
			test: STRING_TEST; word_list, s_32_words: EL_STRING_32_LIST
			word, word_A, first_word: STRING_32; i: INTEGER; s32: EL_STRING_32_ROUTINES
		do
			create word_list.make (20)
			create test
			across Text.lines as line loop
				first_word := s32.substring_to (line.item, ' ', default_pointer)
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
						if test.zs.substring_index_list (word, False).count = 1 then
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
				covers/{ZSTRING}.to_canonically_spaced, covers/{ZSTRING}.is_canonically_spaced
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

	test_to_utf_8
		-- ZSTRING_TEST_SET.test_to_utf_8
		note
			testing:	"[
				covers/{ZSTRING}.to_utf_8,
				covers/{EL_ZSTRING_IMPLEMENTATION}.leading_ascii_count,
				covers/{EL_WRITEABLE_ZSTRING}.append_to_utf_8,
				covers/{ZSTRING}.make_from_utf_8
			]"
		local
			z_word, z_str: ZSTRING; utf_8: STRING; conv: EL_UTF_8_CONVERTER
		do
			create utf_8.make_empty
			across Text.lines as line loop
				utf_8.wipe_out
				across line.item.split (' ') as word loop
					if word.cursor_index > 1 then
						utf_8.append_character (' ')
					end
					z_word := word.item
					z_word.append_to_utf_8 (utf_8)
				end
				if attached conv.string_32_to_string_8 (line.item) as line_utf_8 then
					assert_same_string (Void, utf_8, line_utf_8)
					z_str := line.item
					assert_same_string (Void, z_str.to_utf_8, line_utf_8)
				end
			end
		end

	test_translate
		note
			testing:	"covers/{ZSTRING}.translate"
		local
			test: STRING_TEST
			old_characters, new_characters: ZSTRING
			old_characters_32, new_characters_32: STRING_32
			i, j, count: INTEGER; s: EL_STRING_32_ROUTINES
		do
			create test
			create old_characters_32.make (3); create new_characters_32.make (3)
			count := (Text.character_set.count // 3 - 1)
			from i := 0  until i = count loop
				old_characters_32.wipe_out; new_characters_32.wipe_out
				from j := 1 until j > 3 loop
					old_characters_32.extend (Text.character_set [i * 3 + j])
					new_characters_32.extend (Text.character_set [i * 3 + j + 3])
					j := j + 1
				end
				from j := 1 until j > 2 loop
					if j = 2 then
						new_characters_32 [2] := '%U'
					end
					old_characters := old_characters_32; new_characters := new_characters_32
					test.set (Text.russian_and_english.twin)
					s.translate_deleting_null_characters (test.s_32, old_characters_32, new_characters_32, j = 2)
					test.zs.translate_deleting_null_characters (old_characters, new_characters, j = 2)
					assert ("translate OK", test.is_same)
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Status query tests

	test_ends_with
		-- ZSTRING_TEST_SET.test_ends_with
		note
			testing: "[
				covers/{ZSTRING}.ends_with,
				covers/{ZSTRING}.ends_with_character,
				covers/{ZSTRING}.remove_tail,
				covers/{EL_SUBSTRING_32_ARRAY}.same_substring
			]"
		local
			test: STRING_TEST; assertion_OK: STRING
			index, start_index, end_index: INTEGER
		do
			across Text.lines as line loop
				create test.make (line.item)
				if attached test.word_intervals as list then
					from list.start until list.is_empty loop
						start_index := list.item_lower; end_index := list.last_upper
						test.set_substrings (start_index, end_index)
						assert ("ends_with OK", test.ends_with)
						start_index := start_index - 1
						if test.s_32.valid_index (start_index) then
							test.set_substrings (start_index, end_index)
							assert ("ends_with OK", test.ends_with)
						end
						list.remove
					end
				end
			end
		end

	test_fill_alpha_numeric_intervals
		note
			testing: "covers/{EL_SEARCHABLE_ZSTRING}.fill_alpha_numeric_intervals"
		local
			word_intervals, alpha_numeric_intervals: EL_SPLIT_INTERVALS
			zstr: ZSTRING
		do
			create alpha_numeric_intervals.make_empty
			across 1 |..| 2 as n loop
				across Text.lines as list until list.cursor_index > 3 loop
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
			across Text.lines as line_32 loop
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
			english_32 := Text.lines.last
			english := english_32
			across Text.lines as line loop
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
			across Text.lines as lines loop
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

	test_is_canonically_spaced
		note
			testing: "covers/{ZSTRING}.is_canonically_spaced"
		local
			str, line: ZSTRING; space_index: INTEGER
			canonically_spaced: STRING
		do
			canonically_spaced := "canonically spaced"
			across Text.lines as list loop
				line := list.item
				assert (canonically_spaced, line.is_canonically_spaced)
				space_index := line.index_of (' ', 1)
				if space_index > 0 then
					across << Text.Tab_character, Text.Ogham_space_mark >> as c loop
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
			list_32 := Text.words
			create list.make_from_general (Text.words)
			list_32.ascending_sort; list.ascending_sort
			across list_32 as str_32 loop
				assert ("same string", str_32.item ~ list.i_th (str_32.cursor_index).to_string_32)
			end
		end

	test_same_caseless_characters
		-- ZSTRING_TEST_SET.test_same_caseless_characters
		note
			testing: "covers/{EL_COMPARABLE_ZSTRING}.same_caseless_characters",
						"covers/{EL_COMPARABLE_ZSTRING}.same_characters_8",
						"covers/{EL_COMPARABLE_ZSTRING}.same_characters_32"

		do
			assert_same_characters ("same_caseless_characters OK", True)
		end

	test_same_characters
		-- ZSTRING_TEST_SET.test_same_characters
		note
			testing: "covers/{EL_COMPARABLE_ZSTRING}.same_characters",
						"covers/{EL_COMPARABLE_ZSTRING}.same_characters_8",
						"covers/{EL_COMPARABLE_ZSTRING}.same_characters_32"

		do
			assert_same_characters ("same_characters OK", False)
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
			across Text.lines as line loop
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

	test_starts_with
		note
			testing: "[
				covers/{ZSTRING}.starts_with,
				covers/{ZSTRING}.starts_with_character,
				covers/{ZSTRING}.remove_head,
				covers/{EL_SUBSTRING_32_ARRAY}.same_substring
			]"
		local
			test: STRING_TEST; assertion_OK: STRING
			index, start_index, end_index: INTEGER
		do
			across Text.lines as line loop
				create test.make (line.item)
				if attached test.word_intervals as list then
					from list.start until list.is_empty loop
						list.start
						start_index := list.item_lower; end_index := list.last_upper
						test.set_substrings (start_index, end_index)
						assert ("starts_with OK", test.starts_with)
						start_index := start_index + 1
						if test.s_32.valid_index (start_index) then
							test.set_substrings (start_index, end_index)
							assert ("starts_with OK", test.starts_with)
						end
						list.finish
						list.remove
					end
				end
			end
		end

	test_there_exists_split
		note
			testing: "covers/{ZSTRING}.there_exists_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST
		do
			across Text.lines as line_32 loop
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
			create test
			across Text.words as word loop
				from i := 1 until i > word.item.count loop
					test.set (word.item)
					test.zs.remove (i); test.s_32.remove (i)
					assert ("remove OK", test.is_same)
					i := i + 1
				end
			end
		end

	test_remove_head
		note
			testing: "covers/{ZSTRING}.remove_head", "covers/{ZSTRING}.keep_tail"
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
			testing: "covers/{ZSTRING}.remove_tail", "covers/{ZSTRING}.keep_head"
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

feature -- Access tests

	test_index_of
		note
			testing:	"covers/{ZSTRING}.index_of"
		local
			test: STRING_TEST; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			create test
			across Text.lines as line loop
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
			create test
			across Text.lines as line loop
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
			testing:	"covers/{EL_READABLE_ZSTRING}.new_cursor", "covers/{EL_ZSTRING_ITERATION_CURSOR}.item"
		local
			test: STRING_TEST
		do
			create test
			across Text.lines as line loop
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
			create test
			across Text.lines as line loop
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
			testing: "covers/{ZSTRING}.substring", "covers/{ZSTRING}.substring_index"
		local
			test: STRING_TEST; start_index, end_index, from_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "substring_index OK"
			across Text.lines as line loop
				create test.make (line.item)
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
		note
			testing: "covers/{EL_SEARCHABLE_ZSTRING}.substring_index_in_bounds"
		local
			test: STRING_TEST; start_index, end_index, bound_start_pos, bound_end_pos: INTEGER
			boundary_intervals: EL_SPLIT_INTERVALS; str_32: STRING_32; str: ZSTRING
			assertion_ok: STRING
		do
			assertion_ok := "substring_index_in_bounds OK"
			str_32 := Text.Russian_and_english; str := str_32

			create boundary_intervals.make (str_32, '%N')

			across Text.lines as line loop
				test := line.item
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
			test := Text.Russian_and_english
			across Text.Character_set as c loop
				assert ("same index", test.zs.index_of (c.item, 1) = test.s_32.index_of (c.item, 1))
			end
		end

feature -- Duplication tests

	test_substitute_tuple
		note
			testing:	"[
				covers/{ZSTRING}.append_substring,
				covers/{ZSTRING}.substitute_tuple
			]"
		local
			str_32, template_32: STRING_32; l_word: READABLE_STRING_GENERAL; str, substituted: ZSTRING
			tuple: TUPLE; i, index: INTEGER
		do
			across Text.lines as line loop
				str_32 := line.item
				if line.cursor_index = 1 then
					-- Test escaping the substitution marker
					str_32.replace_substring_all ({STRING_32} "воду", Text.Escaped_substitution_marker)
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
					substituted.replace_substring_general (Text.Escaped_substitution_marker, index, index)
				end
				assert_same_string ("substitute_tuple OK", substituted, str_32)
			end
		end

	test_substring
		-- ZSTRING_TEST_SET.test_substring
		note
			testing: "covers/{ZSTRING}.substring"
		local
			test: STRING_TEST; start_index, end_index: INTEGER
			assertion_ok: STRING
		do
			assertion_ok := "substring OK"
			across Text.lines as line loop
				create test.make (line.item)
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
			end
		end

	test_substring_to
		note
			testing: "covers/{ZSTRING}.substring_to"
		local
			line, full_text: ZSTRING
			start_index: INTEGER
		do
			full_text := Text.russian_and_english
			start_index := 1
			across Text.lines as list loop
				line := list.item
				assert ("same string", full_text.substring_to ('%N', $start_index) ~ line)
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
			full_text := Text.russian_and_english
			start_end_index := full_text.count
			across Text.lines.new_cursor.reversed as list loop
				line := list.item
				assert ("same string", full_text.substring_to_reversed ('%N', $start_end_index) ~ line)
			end
			assert ("valid start_end_index", start_end_index = 0)
		end

feature {NONE} -- Implementation

	assert_same_characters (assertion_OK: STRING; is_case_insenstive: BOOLEAN)
		local
			start_index, end_index: INTEGER; test: STRING_TEST
		do
			across Text.lines as line loop
				if is_case_insenstive then
					create {CASELESS_STRING_TEST} test.make (line.item)
				else
					create test.make (line.item)
				end
				across test.all_word_interval_permutations as permutation loop
					if attached permutation.item as list then
						from list.start until list.after loop
							start_index := list.item_lower; end_index := list.item_upper
							test.set_substrings (start_index, end_index)
							assert (assertion_OK, test.same_characters (start_index))
							list.forth
						end
					end
				end
			end
		end

	change_case (lower_32, upper_32: STRING_32)
		local
			lower, upper: ZSTRING
		do
			lower := lower_32; upper :=  upper_32
			assert_same_string ("to_upper OK", lower.as_upper, upper_32)
			assert_same_string ("to_lower OK", upper.as_lower, lower_32)
		end

	compare_ends_with (str_32, left_32, right_32: STRING_32; str, left, right: ZSTRING)
		local
			ends_with: BOOLEAN
		do
			ends_with := str_32.ends_with (right_32)
			assert ("same result", ends_with = str.ends_with (right))
			assert ("same result", ends_with = str.ends_with (right_32))
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

	test_concatenation (type: INTEGER)
		local
			test, substring_text: STRING_TEST; i, count: INTEGER
		do
			create test
			count := (Text.russian_and_english.count // 5) * 5
			from i := 1 until i > count loop
				substring_text := Text.russian_and_english.substring (i, i + 4)
				test.extend_strings (type, substring_text)

				assert (test.append_type_name (type) + " OK", test.is_same)
				i := i + 5
			end
		end

end