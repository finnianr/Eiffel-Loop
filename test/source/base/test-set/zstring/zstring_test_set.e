note
	description: "Tests for class [$source EL_ZSTRING]"
	notes: "[
		Don't forget to also run the test with the latin-15 codec. See `on_prepare'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:51:25 GMT (Tuesday 4th October 2022)"
	revision: "62"

class
	ZSTRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

	EL_ZSTRING_CONSTANTS

	EL_STRING_32_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_ENCODINGS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("mirror", agent test_mirror)
			eval.call ("split", agent test_split)
			eval.call ("substring_split", agent test_substring_split)
			eval.call ("append", agent test_append)
			eval.call ("append_encoded", agent test_append_encoded)
			eval.call ("append_string_general", agent test_append_string_general)
			eval.call ("append_substring", agent test_append_substring)
			eval.call ("append_substring_general", agent test_append_substring_general)
			eval.call ("append_to_string_32", agent test_append_to_string_32)
			eval.call ("append_unicode", agent test_append_unicode)
			eval.call ("append_utf_8", agent test_append_utf_8)
			eval.call ("case_changing", agent test_case_changing)
			eval.call ("enclose", agent test_enclose)
			eval.call ("fill_character", agent test_fill_character)
			eval.call ("insert_character", agent test_insert_character)
			eval.call ("insert_string", agent test_insert_string)
			eval.call ("left_adjust", agent test_left_adjust)
			eval.call ("prepend", agent test_prepend)
			eval.call ("prepend_substring", agent test_prepend_substring)
			eval.call ("prune_all", agent test_prune_all)
			eval.call ("prune_leading", agent test_prune_leading)
			eval.call ("prune_trailing", agent test_prune_trailing)
			eval.call ("put_unicode", agent test_put_unicode)
			eval.call ("remove_substring", agent test_remove_substring)
			eval.call ("replace_character", agent test_replace_character)
			eval.call ("replace_substring", agent test_replace_substring)
			eval.call ("replace_substring_all", agent test_replace_substring_all)
			eval.call ("right_adjust", agent test_right_adjust)
			eval.call ("to_utf_8", agent test_to_utf_8)
			eval.call ("translate", agent test_translate)
			eval.call ("ends_with", agent test_ends_with)
			eval.call ("for_all_split", agent test_for_all_split)
			eval.call ("has", agent test_has)
			eval.call ("is_canonically_spaced", agent test_is_canonically_spaced)
			eval.call ("order_comparison", agent test_order_comparison)
			eval.call ("same_characters", agent test_same_characters)
			eval.call ("sort", agent test_sort)
			eval.call ("starts_with", agent test_starts_with)
			eval.call ("there_exists_split", agent test_there_exists_split)
			eval.call ("remove", agent test_remove)
			eval.call ("remove_head", agent test_remove_head)
			eval.call ("remove_tail", agent test_remove_tail)
			eval.call ("index_of", agent test_index_of)
			eval.call ("joined", agent test_joined)
			eval.call ("last_index_of", agent test_last_index_of)
			eval.call ("new_cursor", agent test_new_cursor)
			eval.call ("occurrences", agent test_occurrences)
			eval.call ("substring_index", agent test_substring_index)
			eval.call ("substring_index_in_bounds", agent test_substring_index_in_bounds)
			eval.call ("unicode_index_of", agent test_unicode_index_of)
			eval.call ("substring", agent test_substring)
			eval.call ("substring_to", agent test_substring_to)
			eval.call ("substring_to_reversed", agent test_substring_to_reversed)
			eval.call ("to_general", agent test_to_general)
			eval.call ("to_string_32", agent test_to_string_32)
		end

feature -- Conversion tests

	test_mirror
		note
			testing:	"covers/{ZSTRING}.mirror, covers/{ZSTRING}.mirrored"
		local
			pair: STRING_PAIR
		do
			create pair
			across text_words as word loop
				pair.set (word.item)
				assert ("mirror OK", pair.z.mirrored.same_string (pair.uc.mirrored))
			end
		end

	test_split
		note
			testing: "covers/{ZSTRING}.substring", "covers/{ZSTRING}.split", "covers/{ZSTRING}.index_of"
		local
			list: LIST [ZSTRING]; list_32: LIST [STRING_32]
			pair: STRING_PAIR; i: INTEGER
		do
			create pair
			across Text_lines as line loop
				pair.set (line.item)
				from i := 1 until i > 3 loop
					list := pair.z.split_list (pair.uc [i])
					list_32 := pair.uc.split (pair.uc [i])
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
			across text_lines as line loop
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
			str := Text_russian_and_english; delimiter := "Latin"
			across str.substring_split (delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert ("substring_split OK", str.same_string (Text_russian_and_english))
		end

	test_to_general
		note
			testing:	"covers/{ZSTRING}.to_general", "covers/{ZSTRING}.make_from_general"
		local
			pair: STRING_PAIR
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				if attached pair.z.to_general as general then
					assert ("same string", general.same_string (pair.uc))
					assert ("both string 8", attached {STRING} general implies pair.uc.is_valid_as_string_8)
				end
			end
		end

	test_to_string_32
		note
			testing:	"covers/{ZSTRING}.to_string_32", "covers/{ZSTRING}.make_from_general"
		local
			pair: STRING_PAIR
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				assert ("strings equal", pair.is_same)
			end
		end


feature -- Appending tests

	test_append
		do
			test_concatenation ("append")
		end

	test_append_encoded
		local
			pair: STRING_PAIR; encoded: STRING; encoding_id, encoding: NATURAL
			encodeable: EL_ENCODEABLE_AS_TEXT; uncovertable_count: INTEGER
			unicode: ENCODING
		do
			create encodeable.make_default
			create pair
			unicode := Encodings.Unicode
		 	across text_lines as line loop
		 		pair.set (line.item)
				across << 1 |..| 15, 1250 |..| 1258 >> as range loop
					across range.item as n loop
						encoding_id := n.item.to_natural_32
						pair.z.wipe_out
						if encoding_id <= 15 and then encodeable.valid_latin (encoding_id) then
							encodeable.set_latin_encoding (encoding_id)
						elseif encodeable.valid_windows (encoding_id) then
							encodeable.set_windows_encoding (encoding_id)
						end
						encoding := encodeable.encoding
						if encodeable.valid_encoding (encoding) then
							unicode.convert_to (encodeable.as_encoding, pair.uc)
							if unicode.last_conversion_lost_data then
								uncovertable_count := uncovertable_count + 1
							else
								encoded := unicode.last_converted_string_8
								pair.z.append_encoded (unicode.last_converted_string_8, encoding)
								assert ("same string", pair.is_same)
							end
						end
					end
				end
		 	end
		 	assert ("76 not convertable", uncovertable_count = 76)
		end

	test_append_string_general
		note
			testing: "covers/{ZSTRING}.append_string_general", "covers/{ZSTRING}.substring"
		local
			pair, word_pair: STRING_PAIR
		do
			create pair; create word_pair
			across text_words as word loop
				word_pair.wipe_out
				word_pair.uc.share (word.item)
				if not pair.uc.is_empty then
					pair.append_character (' ')
				end
				pair.uc.append (word_pair.uc)
				if attached word_pair.latin_1 as str_8 then
					pair.z.append_string_general (str_8)
				else
					pair.z.append_string_general (word_pair.uc)
				end
				assert ("append_string_general OK", pair.is_same)
				word_pair.z.share (pair.z.substring (pair.z.count - word_pair.uc.count + 1, pair.z.count))
				assert ("substring OK", word_pair.is_same)
			end
		end

	test_append_substring
		note
			testing:	"covers/{ZSTRING}.append_substring", "covers/{ZSTRING}.substitute_tuple"
		local
			str_32, template_32: STRING_32; l_word: READABLE_STRING_GENERAL; str, substituted: ZSTRING
			tuple: TUPLE; i, index: INTEGER
		do
			across text_lines as line loop
				str_32 := line.item
				if line.cursor_index = 1 then
					-- Test escaping the substitution marker
					str_32.replace_substring_all ({STRING_32} "воду", Escaped_substitution_marker)
				end
				template_32 := str_32.twin
				tuple := Substituted_words [line.cursor_index]
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
				substituted := str #$ tuple
				if line.cursor_index = 1 then
					index := substituted.index_of ('%S', 1)
					substituted.replace_substring_general (Escaped_substitution_marker, index, index)
				end
				assert ("substitute_tuple OK", substituted.same_string (str_32))
			end
		end

	test_append_substring_general
		note
			testing: "covers/{ZSTRING}.append_substring_general", "covers/{ZSTRING}.substring"
		local
			line_32: STRING_32; list: EL_SPLIT_STRING_32_LIST; pair: STRING_PAIR
		do
			create pair
			across text_lines as line loop
				line_32 := line.item
				create list.make (line_32, ' ')
				pair.wipe_out
				from list.start until list.after loop
					if list.index > 1 then
						pair.append_character (' ')
					end
					pair.uc.append_substring_general (line_32, list.item_start_index, list.item_end_index)
					if attached pair.latin_1 as str_8 then
						pair.z.append_substring_general (str_8, list.item_start_index, list.item_end_index)
					else
						pair.z.append_substring_general (line_32, list.item_start_index, list.item_end_index)
					end
					list.forth
				end
				assert ("reconstituted line", pair.uc ~ line_32)
				assert ("same line", pair.is_same)
			end
		end

	test_append_to_string_32
		local
			str_32: STRING_32; word: ZSTRING
		do
			across text_lines as line_32 loop
				create str_32.make (0)
				across line_32.item.split (' ') as word_32 loop
					word := word_32.item
					if word_32.cursor_index > 1 then
						str_32.append_character (' ')
					end
					word.append_to_string_32 (str_32)
				end
				assert ("same string", str_32 ~ line_32.item)
			end
		end

	test_append_unicode
		local
			a: ZSTRING
		do
			create a.make_empty
			across Text_russian_and_english as uc loop
				a.append_unicode (uc.item.natural_32_code)
			end
			assert ("append_unicode OK", a.same_string (Text_russian_and_english))
		end

	test_append_utf_8
		local
			utf_8: STRING; conv: EL_UTF_CONVERTER
			pair: STRING_PAIR
		do
			create pair
			across text_lines as line loop
				pair.wipe_out
				across conv.string_32_to_utf_8_string_8 (line.item).split (' ') as utf_word loop
					if pair.uc.count > 0 then
						pair.append_character (' ')
					end
					pair.z.append_utf_8 (utf_word.item)
					pair.uc.append (conv.utf_8_string_8_to_string_32 (utf_word.item))
					assert ("same string", pair.is_same)
				end
			end
		end

feature -- Prepending tests

	test_prepend
		do
			test_concatenation ("prepend")
		end

	test_prepend_substring
		local
			pair: STRING_PAIR; line: ZSTRING
			word_list: EL_OCCURRENCE_INTERVALS [STRING_32]
			start_index, end_index: INTEGER; s: EL_STRING_32_ROUTINES
		do
			across text_lines as line_32 loop
				line := line_32.item
				create pair
				create word_list.make (line_32.item, ' ')
				start_index := 1
				from word_list.start until word_list.after loop
					end_index := word_list.item_lower - 1
					pair.uc.prepend_substring (line_32.item, start_index, end_index)
					pair.uc.prepend_substring (line_32.item, word_list.item_lower, word_list.item_upper)
					pair.z.prepend_substring (line, start_index, end_index)
					pair.z.prepend_substring (line, word_list.item_lower, word_list.item_upper)
					assert ("same string", pair.is_same)
					start_index := word_list.item_upper + 1
					word_list.forth
				end
			end
		end

feature -- Element change tests

	test_case_changing
		do
			change_case (Lower_case_characters, Upper_case_characters)
			change_case (Text_russian_and_english.as_lower, Text_russian_and_english.as_upper)
--			change_case (Lower_case_mu, Upper_case_mu)
		end

	test_enclose
		note
			testing:	"covers/{ZSTRING}.enclose", "covers/{ZSTRING}.quote"
		local
			pair: STRING_PAIR
		do
			create pair
			across text_words as word loop
				pair.set (word.item)
				pair.uc.prepend_character ('"'); pair.uc.append_character ('"')
				pair.z.quote (2)
				assert ("enclose OK", pair.is_same)
			end
		end

	test_fill_character
		note
			testing:	"covers/{ZSTRING}.fill_character"
		local
			pair: STRING_PAIR
		do
			across 1 |..| 2 as index loop
				create pair.make_filled (text_russian [index.item], 3)
				assert ("same string", pair.is_same)
			end
		end

	test_insert_character
		note
			testing:	"covers/{ZSTRING}.insert_character"
		local
			str_32, word_32: STRING_32; word: ZSTRING; uc_1, uc_2: CHARACTER_32
		do
			across text_words as list loop
				word_32 := list.item
				if word_32.count > 1 then
					word := word_32
					uc_1 := word_32 [1]; uc_2 := word_32 [word_32.count]
					word := word_32.substring (2, word_32.count - 1)
					word.insert_character (uc_1, 1)
					word.insert_character (uc_2, word.count + 1)
					assert ("insert_character OK", word.same_string (word_32))
				end
			end
		end

	test_insert_string
		note
			testing:	"covers/{ZSTRING}.insert_string", "covers/{ZSTRING}.remove_substring"
		local
			pair: STRING_PAIR; insert: ZSTRING; word_list: EL_SPLIT_ZSTRING_LIST
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				create word_list.make_by_string (pair.uc, " ")
				from word_list.start until word_list.after loop
					insert := word_list.item
					pair.z.remove_substring (word_list.item_start_index, word_list.item_end_index)
					pair.z.insert_string (insert, word_list.item_start_index)
					assert ("insert_string OK", pair.is_same)
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
			across text_lines as list loop
				line_32 := list.item.twin; line := line_32
				line_32.append_string_general (" 100-abc")
				joined := line.joined ([' ', 100, "-abc"])
				assert ("line not modified", line.same_string (list.item))
				assert ("same joined", joined.same_string (line_32))
			end
		end

	test_left_adjust
		note
			testing:	"covers/{ZSTRING}.left_adjust"
		do
			do_pruning_test (Left_adjust)
		end

	test_prune_all
		local
			pair: STRING_PAIR; uc: CHARACTER_32
		do
			create pair
			across Text_characters as char loop
				uc := char.item
				across text_lines as line loop
					pair.set (line.item)
					pair.uc.prune_all (uc); pair.z.prune_all (uc)
					assert ("prune_all OK", pair.is_same)
				end
			end
			across text_words as word loop
				pair.set (word.item)
				from until pair.uc.is_empty loop
					uc := pair.uc [1]
					pair.uc.prune_all (uc); pair.z.prune_all (uc)
					assert ("prune_all OK", pair.is_same)
				end
			end
		end

	test_prune_leading
		note
			testing:	"covers/{ZSTRING}.prune_all_trailing"
		do
			do_pruning_test (Prune_leading)
		end

	test_prune_trailing
		note
			testing:	"covers/{ZSTRING}.prune_all_trailing"
		do
			do_pruning_test (Prune_trailing)
		end

	test_put_unicode
		note
			testing: "covers/{ZSTRING}.put_unicode"
		local
			pair: STRING_PAIR; uc, old_uc: CHARACTER_32; i: INTEGER
		do
			uc := 'д'
			pair := text_russian
			across text_russian as c loop
				i := c.cursor_index; old_uc := c.item
				pair.uc.put (uc, i); pair.z.put (uc, i)
				assert ("put_unicode OK", pair.is_same)
			--	Restore
				pair.uc.put (old_uc, i); pair.z.put (old_uc, i)
				assert ("put_unicode OK", pair.is_same)
			end
		end

	test_remove_substring
		note
			testing: "covers/{ZSTRING}.remove_substring"
		local
			pair: STRING_PAIR; substring: STRING_32
			l_interval: INTEGER_INTERVAL; i, lower, upper, offset: INTEGER
		do
			create pair
			across Text_word_intervals as interval loop
				from offset := 0 until offset > (interval.item.count // 2).max (1) loop
					l_interval := (interval.item.lower + offset) |..| (interval.item.upper + offset)
					if Text_russian_and_english.valid_index (l_interval.lower)
						and then Text_russian_and_english.valid_index (l_interval.upper)
					then
						substring := Text_russian_and_english.substring (l_interval.lower, l_interval.upper) -- Debug
						pair.set (Text_russian_and_english.twin)
						pair.uc.remove_substring (l_interval.lower, l_interval.upper)
						pair.z.remove_substring (l_interval.lower, l_interval.upper)
						assert ("remove_substring OK", pair.is_same)
					end
					offset := offset + (interval.item.count // 2).max (1)
				end
			end
			across text_words as word loop
				pair.set (word.item)
				pair.z.remove_substring (1, pair.z.count)
				pair.uc.remove_substring (1, pair.uc.count)
				assert ("empty string", pair.uc.is_empty)
				assert ("same strings", pair.is_same)
			end
		end

	test_replace_character
		note
			testing:	"covers/{ZSTRING}.replace_character"
		local
			pair: STRING_PAIR; uc_new, uc_old: CHARACTER_32
			s: EL_STRING_32_ROUTINES
		do
			across text_russian as uc loop
				pair := text_russian
				if not uc.is_last then
					uc_old := uc.item
					uc_new := pair.uc [uc.cursor_index + 1]
				end
				s.replace_character (pair.uc, uc_old, uc_new)
				pair.z.replace_character (uc_old, uc_new)
				assert ("replace_character OK", pair.is_same)
			end
		end

	test_replace_substring
		note
			testing:	"covers/{ZSTRING}.replace_substring"
		local
			pair, word_pair: STRING_PAIR
			word_list_32: EL_STRING_32_LIST; index, start_index, end_index: INTEGER
			space_intervals: EL_OCCURRENCE_INTERVALS [STRING_32]
			line_list: like text_lines
		do
			create pair; create word_pair
			create space_intervals.make_empty
			create word_list_32.make (50)
			line_list := text_lines
			across line_list as line loop
				if line.is_first or line.is_last then
					across line.item.split (' ') as list loop
						word_list_32.extend (list.item)
					end
				end
			end
			across word_list_32 as list loop
				word_pair.set (list.item)
				across text_lines as line loop
					pair.set (line.item)
					space_intervals.fill (pair.uc, ' ', 0)
					start_index := space_intervals.first_lower + 1
					end_index := space_intervals.i_th_lower (2) - 1
					pair.uc.replace_substring (word_pair.uc, start_index, end_index)
					pair.z.replace_substring (word_pair.z, start_index, end_index)
					assert ("same characters", pair.is_same)
				end
			end
		end

	test_replace_substring_all
		note
			testing:	"covers/{ZSTRING}.replace_substring_all"
		local
			pair: STRING_PAIR
			word_32, previous_word_32: STRING_32; word, previous_word: ZSTRING
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				create previous_word_32.make_empty; previous_word := previous_word_32
				across text_words as list loop
					word_32 := list.item; word := word_32
					pair.uc.replace_substring_all (word_32, previous_word_32)
					pair.z.replace_substring_all (word, previous_word)
					assert ("replace_substring_all OK", pair.is_same)
					previous_word_32 := word_32; previous_word := word
				end
			end
		end

	test_right_adjust
		note
			testing:	"covers/{ZSTRING}.right_adjust"
		do
			do_pruning_test (Right_adjust)
		end

	test_to_utf_8
		note
			testing:	"covers/{ZSTRING}.to_utf_8", "covers/{ZSTRING}.make_from_utf_8"
		local
			pair: STRING_PAIR
			str_2: ZSTRING; str_utf_8: STRING
		do
			create pair
			across text_words as word loop
				pair.set (word.item)
				str_utf_8 := pair.z.to_utf_8 (True)
				assert ("to_utf_8 OK", str_utf_8.same_string (Utf_8_codec.as_utf_8 (pair.uc, False)))
				create str_2.make_from_utf_8 (str_utf_8)
				assert ("make_from_utf_8 OK", str_2.same_string (pair.uc))
			end
		end

	test_translate
		note
			testing:	"covers/{ZSTRING}.translate"
		local
			pair: STRING_PAIR
			old_characters, new_characters: ZSTRING
			old_characters_32, new_characters_32: STRING_32
			i, j, count: INTEGER; s: EL_STRING_32_ROUTINES
		do
			create pair
			create old_characters_32.make (3); create new_characters_32.make (3)
			count := (Text_characters.count // 3 - 1)
			from i := 0  until i = count loop
				old_characters_32.wipe_out; new_characters_32.wipe_out
				from j := 1 until j > 3 loop
					old_characters_32.extend (Text_characters [i * 3 + j])
					new_characters_32.extend (Text_characters [i * 3 + j + 3])
					j := j + 1
				end
				from j := 1 until j > 2 loop
					if j = 2 then
						new_characters_32 [2] := '%U'
					end
					old_characters := old_characters_32; new_characters := new_characters_32
					pair.set (Text_russian_and_english.twin)
					s.translate_deleting_null_characters (pair.uc, old_characters_32, new_characters_32, j = 2)
					pair.z.translate_deleting_null_characters (old_characters, new_characters, j = 2)
					assert ("translate OK", pair.is_same)
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Status query tests

	test_ends_with
		note
			testing: "covers/{ZSTRING}.ends_with", "covers/{ZSTRING}.remove_tail",
						"covers/{EL_SUBSTRING_32_ARRAY}.same_substring"
		do
			for_all_text_splits (agent compare_ends_with)
		end

	test_for_all_split
		note
			testing: "covers/{ZSTRING}.for_all_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST; s: EL_ZSTRING_ROUTINES
		do
			across text_lines as line_32 loop
				line := line_32.item
				create word_list.make_word_split (line)
				assert ("word is in word_list", line.for_all_split (s.character_string (' '), agent word_list.has))
			end
		end

	test_has
		note
			testing: "covers/{ZSTRING}.has"
		local
			english: ZSTRING; english_32: STRING_32
		do
			english_32 := text_lines.last
			english := english_32
			across text_lines as line loop
				across line.item as uc loop
					assert ("has OK", english.has (uc.item) ~ english_32.has (uc.item))
				end
			end
		end

	test_is_canonically_spaced
		note
			testing: "covers/{ZSTRING}.is_canonically_spaced"
		local
			str: ZSTRING
		do
			str := " one two "
			assert ("is_canonically_spaced", str.is_canonically_spaced)
			str [5] := '%T'
			assert ("not is_canonically_spaced", not str.is_canonically_spaced)
			assert ("is_canonically_spaced", str.as_canonically_spaced.is_canonically_spaced)
			str [5] := ' '
			str.insert_character (' ', 5)
			assert ("not is_canonically_spaced", not str.is_canonically_spaced)
			assert ("is_canonically_spaced", str.as_canonically_spaced.is_canonically_spaced)
		end

	test_order_comparison
		note
			testing: "covers/{EL_READABLE_ZSTRING}.order_comparison"
		local
			list_32: EL_STRING_32_LIST; list: EL_ZSTRING_LIST
			left_32, right_32: STRING_32; left, right: ZSTRING
		do
			list_32 := text_words
			create list.make_from_general (text_words)
			list_32.sort; list.sort
			across list_32 as str_32 loop
				assert ("same string", str_32.item ~ list.i_th (str_32.cursor_index).to_string_32)
			end
		end

	test_same_characters
		local
			line, word: ZSTRING; i: INTEGER
			word_list: EL_ZSTRING_LIST
		do
			across text_lines as l loop
				line := l.item
				create word_list.make_word_split (l.item)
				i := 1
				across word_list as w loop
					word := w.item
					i := line.substring_index (word, i)
					assert ("same characters", line.same_characters (word, 1, word.count, i))
				end
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
			across text_lines as line loop
				sorted.wipe_out; sorted_32.wipe_out
				across line.item.split (' ') as w loop
					word := w.item
					sorted.extend (word); sorted_32.extend (w.item)
				end
				sorted.sort; sorted_32.sort
				assert ("sorting OK",
					across sorted as l_a all
						l_a.item.same_string (sorted_32.i_th (l_a.cursor_index))
					end
				)
			end
		end

	test_starts_with
		note
			testing: "covers/{ZSTRING}.starts_with", "covers/{ZSTRING}.remove_head",
						"covers/{EL_SUBSTRING_32_ARRAY}.same_substring"
		do
			for_all_text_splits (agent compare_starts_with)
		end

	test_there_exists_split
		note
			testing: "covers/{ZSTRING}.there_exists_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST
			s: EL_ZSTRING_ROUTINES
		do
			across text_lines as line_32 loop
				line := line_32.item
				create word_list.make_word_split (line)
				across word_list as word loop
					assert (
						"word is in word_list",
						line.there_exists_split (s.character_string (' '), agent (word.item).is_equal)
					)
				end
			end
		end

feature -- Removal tests

	test_remove
		note
			testing: "covers/{ZSTRING}.remove"
		local
			pair: STRING_PAIR; i: INTEGER
		do
			create pair
			across text_words as word loop
				from i := 1 until i > word.item.count loop
					pair.set (word.item)
					pair.z.remove (i); pair.uc.remove (i)
					assert ("remove OK", pair.is_same)
					i := i + 1
				end
			end
		end

	test_remove_head
		note
			testing: "covers/{ZSTRING}.remove_head", "covers/{ZSTRING}.keep_tail"
		local
			pair: STRING_PAIR; pos: INTEGER
		do
			pair := Text_russian_and_english.twin
			from until pair.uc.is_empty loop
				pos := pair.uc.index_of (' ', pair.uc.count)
				if pos > 0 then
					pair.uc.remove_head (pos); pair.z.remove_head (pos)
				else
					pair.uc.remove_head (pair.uc.count) pair.z.remove_head (pair.z.count)
				end
				assert ("remove_head OK", pair.is_same)
			end
		end

	test_remove_tail
		note
			testing: "covers/{ZSTRING}.remove_tail", "covers/{ZSTRING}.keep_head"
		local
			pair: STRING_PAIR; pos: INTEGER
		do
			pair := Text_russian_and_english.twin
			from until pair.uc.is_empty loop
				pos := pair.uc.last_index_of (' ', pair.uc.count)
				if pos > 0 then
					pair.uc.remove_tail (pos); pair.z.remove_tail (pos)
				else
					pair.uc.remove_tail (pair.uc.count) pair.z.remove_tail (pair.z.count)
				end
				assert ("remove_tail OK", pair.is_same)
			end
		end

feature -- Access tests

	test_index_of
		note
			testing:	"covers/{ZSTRING}.index_of"
		local
			pair: STRING_PAIR; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				across Text_characters as char loop
					uc := char.item
					across << 1, pair.uc.count // 2 >> as value loop
						i := value.item
						assert ("index_of OK", pair.z.index_of (uc, i) = pair.uc.index_of (uc, i))
					end
				end
			end
		end

	test_last_index_of
		note
			testing:	"covers/{ZSTRING}.last_index_of"
		local
			pair: STRING_PAIR; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				across Text_characters as char loop
					uc := char.item
					across << pair.uc.count, pair.uc.count // 2 >> as value loop
						i := value.item
						assert ("last_index_of OK", pair.z.last_index_of (uc, i) = pair.uc.last_index_of (uc, i))
					end
				end
			end
		end

	test_new_cursor
		note
			testing:	"covers/{EL_READABLE_ZSTRING}.new_cursor"
		local
			pair: STRING_PAIR
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				across pair.z as c loop
					assert ("same character", c.item = pair.uc [c.cursor_index])
				end
			end
		end

	test_occurrences
		note
			testing:	"covers/{ZSTRING}.occurrences"
		local
			pair: STRING_PAIR; uc: CHARACTER_32
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				across Text_characters as char loop
					uc := char.item
				end
				assert ("occurrences OK", pair.z.occurrences (uc) ~ pair.uc.occurrences (uc))
			end
		end

	test_substring_index
		note
			testing: "covers/{ZSTRING}.substring", "covers/{ZSTRING}.substring_index"
		local
			pair: STRING_PAIR; search_word: ZSTRING; pos, pos_32: INTEGER
		do
			create pair
			across text_lines as line loop
				pair.set (line.item)
				across text_words as search_word_32 loop
					search_word := search_word_32.item
					pos := pair.z.substring_index (search_word, 1)
					pos_32 := pair.uc.substring_index (search_word_32.item, 1)
					assert ("substring_index OK", pos = pos_32)
					if pos_32 > 0 then
						assert (
							"substring_index OK", pair.z.same_characters (pair.uc, pos_32, pos_32 + search_word_32.item.count - 1, pos)
						)
					end
				end
			end
		end

	test_substring_index_in_bounds
		note
			testing: "covers/{EL_SEARCHABLE_ZSTRING}.substring_index_in_bounds"
		local
			str_32, word_32: STRING_32; str, word: ZSTRING
			i, count, index, start_pos, end_pos, substring_index, substring_index_32: INTEGER; word_list: EL_STRING_32_LIST
		do
			across text_lines as line loop
				str_32 := line.item; str := str_32
				create word_list.make_word_split (str_32)
				across word_list as list loop
					word_32 := list.item; word := word_32
					index := str_32.substring_index (word_32, 1)
					if index = 1 then
						start_pos := 1
					else
						start_pos := (index - 5).max (1)
					end
					end_pos := index + word_32.count - 1
					across << end_pos, end_pos - 1 >> as n loop
						end_pos := n.item
						if end_pos > start_pos then
							substring_index_32 := str_32.substring_index_in_bounds (word_32, start_pos, end_pos)
							substring_index := str.substring_index_in_bounds (word, start_pos, end_pos)
							assert ("same index", substring_index_32 = substring_index)
						end
					end
				end
			end
		end

	test_unicode_index_of
		note
			testing: "covers/{ZSTRING}.substring", "covers/{ZSTRING}.index_of"
		do
			across << (' ').to_character_32, 'и' >> as c loop
				unicode_index_of (Text_russian_and_english, c.item)
			end
		end

feature -- Duplication tests

	test_substring
		note
			testing: "covers/{ZSTRING}.substring"
		local
			pair: STRING_PAIR; i, count: INTEGER
		do
			create pair
			pair.set (Text_russian_and_english)
			count := pair.uc.count
			from i := 1 until (i + 4) > count loop
				assert ("substring OK",  pair.z.substring (i, i + 4).same_string (pair.uc.substring (i, i + 4)))
				i := i + 1
			end
		end

	test_substring_to
		note
			testing: "covers/{ZSTRING}.substring_to"
		local
			line, full_text: ZSTRING
			start_index: INTEGER
		do
			full_text := Text_russian_and_english
			start_index := 1
			across text_lines as list loop
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
			full_text := Text_russian_and_english
			start_end_index := full_text.count
			across text_lines.new_cursor.reversed as list loop
				line := list.item
				assert ("same string", full_text.substring_to_reversed ('%N', $start_end_index) ~ line)
			end
			assert ("valid start_end_index", start_end_index = 0)
		end

feature {NONE} -- Implementation

	change_case (lower_32, upper_32: STRING_32)
		local
			lower, upper: ZSTRING
		do
			lower := lower_32; upper :=  upper_32
			assert ("to_upper OK", lower.as_upper.same_string (upper_32))
			assert ("to_lower OK", upper.as_lower.same_string (lower_32))
		end

	compare_ends_with (str_32, left_32, right_32: STRING_32; str, left, right: ZSTRING)
		do
			assert ("same result", str_32.ends_with (right_32) = str.ends_with (right))
		end

	compare_starts_with (str_32, left_32, right_32: STRING_32; str, left, right: ZSTRING)
		do
			assert ("same result", str_32.starts_with (left_32) = str.starts_with (left))
		end

	do_pruning_test (type: STRING)
		local
			pair: STRING_PAIR; op_name: STRING
		do
			create pair
			across text_words as word loop
				pair.set (word.item)
				across << Tab_character, Ogham_space_mark >> as c loop
					across 1 |..| 2 as n loop
						if type = Right_adjust or type = Prune_trailing then
							pair.uc.append_character (c.item)
							op_name := "append_character"
						else
							pair.uc.prepend_character (c.item)
							op_name := "prepend_character"
						end
						pair.set_z_from_uc
					end
					assert (op_name + " OK", pair.is_same)

					if type = Left_adjust then
						pair.z.left_adjust; pair.uc.left_adjust
					elseif type = Right_adjust then
						pair.z.right_adjust; pair.uc.right_adjust
					elseif type = Prune_trailing then
						pair.z.prune_all_trailing (c.item); pair.uc.prune_all_trailing (c.item)
					end
					assert (type + " OK", pair.is_same)
				end
			end
		end

	for_all_text_splits (test: PROCEDURE [STRING_32, STRING_32, STRING_32, ZSTRING, ZSTRING, ZSTRING])
		local
			str_32, left_32, right_32: STRING_32; str, left, right: ZSTRING; split_position: INTEGER
		do
			across text_lines as line loop
				str_32 := line.item; str := str_32
				across 0 |..| 5 as n loop
					if n.item = 5 then
						split_position := str_32.count
					elseif n.item = 0 then
						split_position := 0
					else
						split_position := str_32.count * n.item // 5
					end
					left_32 := str_32.substring (1, split_position)
					right_32 := str_32.substring (split_position.max (1), str_32.count)
					left := left_32; right := right_32
					test (str_32, left_32, right_32, str, left, right)
				end
			end
		end

	test_concatenation (type: STRING)
		local
			pair, substring_pair: STRING_PAIR; i, count: INTEGER
		do
			create pair
			count := (Text_russian_and_english.count // 5) * 5
			from i := 1 until i > count loop
				substring_pair := Text_russian_and_english.substring (i, i + 4)
				if type ~ once "append" then
					pair.z.append (substring_pair.z);  pair.uc.append (substring_pair.uc)
				else
					pair.z.prepend (substring_pair.z);  pair.uc.prepend (substring_pair.uc)
				end
				assert (type + " OK", pair.is_same)
				i := i + 5
			end
		end

	unicode_index_of (str_32: STRING_32; uc: CHARACTER_32)
		local
			str, part_a: ZSTRING; part_32: STRING_32
		do
			str := str_32
			part_a := str.substring (1, str.index_of (uc, 1))
			part_32 := str_32.substring (1, str_32.index_of (uc, 1))
			assert ("unicode_index_of OK", part_a.same_string (part_32))
		end

feature {NONE} -- String 8 constants

	Left_adjust: STRING = "left_adjust"

	Prune_leading: STRING = "prune_leading"

	Prune_trailing: STRING = "prune_trailing"

	Right_adjust: STRING = "right_right"

feature {NONE} -- Constants

	Substituted_words: ARRAY [TUPLE]
		once
			Result := <<
				[{STRING_32} "и", {STRING_32} "съесть",{STRING_32} "лезть"],
				["eat", "fish", "catching"],
				[1, 1],
				[15],
				['´'],
				['€']
			>>
		ensure
			same_number: Result.count = Text_russian_and_english.occurrences ('%N') + 1
		end

end