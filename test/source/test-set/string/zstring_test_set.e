note
	description: "Tests for class EL_ZSTRING"
	notes: "[
		Don't forget to also run the test with the latin-15 codec. See `on_prepare'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:03:10 GMT (Monday 1st July 2019)"
	revision: "13"

class
	ZSTRING_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

	TEST_STRING_CONSTANTS
		undefine
			default_create
		end

	EL_ZSTRING_CONSTANTS
		undefine
			default_create
		end

	EL_MODULE_STRING_32

	EL_SHARED_ZCODEC

	EL_SHARED_UTF_8_ZCODEC

feature {NONE} -- Events

	on_prepare
		do
--			set_system_codec (create {EL_ISO_8859_1_ZCODEC}.make)
		end

feature -- Conversion tests

	test_mirror
		note
			testing:	"covers/{ZSTRING}.mirror"
		local
			str_32, mirror_32: STRING_32; str, mirror: ZSTRING
		do
			across Text_words as word loop
				str_32 := word.item; str := str_32
				mirror_32 := str_32.mirrored
				mirror := str.mirrored
				assert ("mirror OK", mirror.to_unicode ~ mirror_32)
			end
		end

	test_split
		note
			testing: "covers/{ZSTRING}.substring, covers/{ZSTRING}.split, covers/{ZSTRING}.index_of"
		local
			proverb: ZSTRING; word_list: LIST [ZSTRING]; words_32: LIST [STRING_32]
		do
			proverb := Text_russian_and_english
			across << 'ь', (' ').to_character_32 >> as c loop
				word_list := proverb.split (c.item)
				words_32 := Text_russian_and_english.split (c.item)
				assert ("same word count", word_list.count = words_32.count)
				if word_list.count = words_32.count then
					from word_list.start; words_32.start until word_list.after loop
						assert ("test_split OK", word_list.item.to_unicode ~ words_32.item)
						word_list.forth; words_32.forth
					end
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
			across Text_lines as line loop
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
			assert ("substring_split OK", str.to_unicode ~ Text_russian_and_english)
		end

feature -- Element change tests

	test_append
		do
			test_concatenation ("append")
		end

	test_append_to_string_32
		local
			str_32: STRING_32; word: ZSTRING
		do
			across Text_lines as line_32 loop
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
			assert ("append_unicode OK", a.to_unicode ~ Text_russian_and_english)
		end

	test_append_string_general
		note
			testing: "covers/{ZSTRING}.append_string_general", "covers/{ZSTRING}.substring"
		local
			str_32, word_32: STRING_32; str, l_word: ZSTRING
		do
			create str_32.make_empty; create str.make_empty
			across Text_words as word loop
				word_32 := word.item
				if not str_32.is_empty then
					str_32.append_character (' '); str.append_character (' ')
				end
				str_32.append (word_32)
				str.append_string_general (word_32)
				assert ("append_string_general OK", str.to_unicode ~ str_32)
				l_word := str.substring (str.count - word_32.count + 1, str.count)
				assert ("substring OK", l_word.to_unicode ~ word_32)
			end
		end

	test_append_substring
		note
			testing:	"covers/{ZSTRING}.append_substring", "covers/{ZSTRING}.substitute_tuple"
		local
			str_32, template_32: STRING_32; l_word: READABLE_STRING_GENERAL; str, substituted: ZSTRING
			tuple: TUPLE; i, index: INTEGER
		do
			across Text_lines as line loop
				str_32 := line.item
				if line.cursor_index = 1 then
					-- Test escaping the substitution marker
					str_32.replace_substring_all ({STRING_32} "воду", Escaped_substitution_marker)
				end
				template_32 := str_32.twin
				tuple := Substituted_words [line.cursor_index]
				index := 0
				from i := 1 until i > tuple.count loop
					if tuple.is_reference_item (i) and then
						attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as word
					then
						l_word := word
					elseif tuple.is_integer_32_item (i) then
						l_word := tuple.integer_32_item (i).out
					end
					index := template_32.substring_index (l_word, 1)
					template_32.replace_substring ("%S", index, index + l_word.count - 1)
					i := i + 1
				end
				str := template_32
				substituted := str #$ tuple
				if line.cursor_index = 1 then
					index := substituted.index_of ('%S', 1)
					substituted.replace_substring_general (Escaped_substitution_marker, index, index)
				end
				assert ("substitute_tuple OK", substituted.to_unicode ~ str_32)
			end
		end

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
			str_32: STRING_32; str: ZSTRING
		do
			across Text_words as word loop
				str_32 := word.item; str := str_32
				str_32.prepend_character ('"'); str_32.append_character ('"')
				str.quote (2)
				assert ("enclose OK", str.to_unicode ~ str_32)
			end
		end


	test_insert_character
		note
			testing:	"covers/{ZSTRING}.insert_character"
		local
			str_32: STRING_32; str: ZSTRING; uc: CHARACTER_32
			i: INTEGER
		do
			across Text_words as word loop
				uc := word.item [1]
				across Text_lines as line loop
					from i := 1 until i > 5 loop
						str_32 := line.item.twin; str := str_32
						str_32.insert_character (uc, i); str.insert_character (uc, i)
						assert ("insert_character OK", str.to_unicode ~ str_32)
						i := i + 1
					end
				end
			end
		end

	test_insert_string
		note
			testing:	"covers/{ZSTRING}.insert_string"
		local
			str, insert: ZSTRING; str_32, insert_32: STRING_32
			i: INTEGER
		do
			across Text_words as word loop
				insert_32 := word.item; insert := insert_32
				across Text_lines as line loop
					from i := 1 until i > line.item.count + 1 loop
						str_32 := line.item.twin; str := str_32
						str_32.insert_string (insert_32, i)
						str.insert_string (insert, i)
						assert ("insert_string OK", str.to_unicode ~ str_32)
						i := i + 1
					end
				end
			end
		end

	test_left_adjust
		note
			testing:	"covers/{ZSTRING}.left_adjust"
		do
			do_pruning_test (Left_adjust)
		end

	test_prepend
		do
			test_concatenation ("prepend")
		end

	test_prune_all
		local
			str: ZSTRING; str_32: STRING_32; uc: CHARACTER_32
		do
			across Text_characters as char loop
				uc := char.item
				across Text_lines as line loop
					str_32 := line.item.twin; str := str_32
					str_32.prune_all (uc); str.prune_all (uc)
					assert ("prune_all OK", str.to_unicode ~ str_32)
				end
			end
			across Text_words as word loop
				str_32 := word.item.twin; str := str_32
				from until str_32.is_empty loop
					uc := str_32 [1]
					str_32.prune_all (uc); str.prune_all (uc)
					assert ("prune_all OK", str.to_unicode ~ str_32)
				end
			end
		end

	test_prune_leading
		note
			testing:	"covers/{ZSTRING}.prune_leading"
		do
			do_pruning_test (Prune_leading)
		end

	test_prune_trailing
		note
			testing:	"covers/{ZSTRING}.prune_trailing"
		do
			do_pruning_test (Prune_trailing)
		end

	test_put_unicode
		note
			testing: "covers/{ZSTRING}.put_unicode"
		local
			str_32: STRING_32; str: ZSTRING
			uc: CHARACTER_32; i: INTEGER
		do
			across Text_words as word loop
				uc := word.item [1]
				across Text_lines as line loop
					from i := line.item.index_of (uc, 1) until i = 0 loop
						str_32 := line.item.twin; str := str_32
						str_32.put_code (uc.natural_32_code, i); str.put_unicode (uc.natural_32_code, i)
						assert ("put_unicode OK", str.to_unicode ~ str_32)
						i := line.item.index_of (uc, i + 1)
					end
				end
			end
		end

	test_remove_substring
		note
			testing: "covers/{ZSTRING}.remove_substring"
		local
			str: ZSTRING; str_32, substring: STRING_32
			l_interval: INTEGER_INTERVAL; i, lower, upper, offset: INTEGER
		do
			across Text_word_intervals as interval loop
				from offset := 0 until offset > (interval.item.count // 2).max (1) loop
					l_interval := (interval.item.lower + offset) |..| (interval.item.upper + offset)
					if Text_russian_and_english.valid_index (l_interval.lower)
						and then Text_russian_and_english.valid_index (l_interval.upper)
					then
						substring := Text_russian_and_english.substring (l_interval.lower, l_interval.upper) -- Debug
						str_32 := Text_russian_and_english.twin; str := str_32
						str_32.remove_substring (l_interval.lower, l_interval.upper)
						str.remove_substring (l_interval.lower, l_interval.upper)
						assert ("remove_substring OK", str.to_unicode ~ str_32)
					end
					offset := offset + (interval.item.count // 2).max (1)
				end
			end
			across Text_words as word loop
				str_32 := word.item.twin; str := str_32
				str.remove_substring (1, str.count)
				str_32.remove_substring (1, str_32.count)
			end
		end

	test_replace_substring
		note
			testing:	"covers/{ZSTRING}.replace_substring"
		local
			str, word: ZSTRING; str_32, substring: STRING_32
			l_interval: INTEGER_INTERVAL; index: INTEGER
		do
			across Text_words as word_32 loop
				-- Replace each word
				word := word_32.item
				index := word_32.cursor_index

				across Text_word_intervals as interval loop
					l_interval := interval.item
					substring := Text_russian_and_english.substring (l_interval.lower, l_interval.upper)
					str_32 := Text_russian_and_english.twin; str := str_32
					str_32.replace_substring (word_32.item, l_interval.lower, l_interval.upper)
					str.replace_substring (word, l_interval.lower, l_interval.upper)
					assert ("replace_substring OK", str.to_unicode ~ str_32)
				end
			end
		end

	test_replace_substring_all
		note
			testing:	"covers/{ZSTRING}.replace_substring_all"
		local
			str_32, word_32, previous_word_32: STRING_32; str, word, previous_word: ZSTRING
		do
			previous_word_32 := Text_words.last; previous_word := previous_word_32
			across Text_words as w loop
				word_32 := w.item; word := word_32
				across Text_lines as line loop
					str_32 := line.item.twin
					str_32.append_character (' ')
					str_32.append (line.item)
					str := str_32
					str_32.replace_substring_all (word_32, previous_word_32)
					str.replace_substring_all (word, previous_word)
					assert ("replace_substring_all OK", str.to_unicode ~ str_32)
				end
				previous_word_32 := word_32; previous_word := word
			end
		end

	test_replace_character
		note
			testing:	"covers/{ZSTRING}.replace_character"
		local
			str_32: STRING_32; str: ZSTRING; uc_new, uc_old: CHARACTER_32
		do
			across Text_words as word loop
				uc_old := word.item [1]
				uc_new := word.item [word.item.count]
				across Text_lines as line loop
					str_32 := line.item.twin; str := str_32
					String_32.replace_character (str_32, uc_old, uc_new)
					str.replace_character (uc_old, uc_new)
					assert ("replace_character OK", str.to_unicode ~ str_32)
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
			str, str_2: ZSTRING; str_utf_8: STRING; str_32: STRING_32
		do
			across Text_words as word loop
				str_32 := word.item; str := str_32
				str_utf_8 := str.to_utf_8
				assert ("to_utf_8 OK", str_utf_8 ~ Utf_8_codec.as_utf_8 (str_32, False))
				create str_2.make_from_utf_8 (str_utf_8)
				assert ("make_from_utf_8 OK", str_2.to_unicode ~ str_32)
			end
		end

	test_translate
		note
			testing:	"covers/{ZSTRING}.translate"
		local
			str, old_characters, new_characters: ZSTRING
			str_32, old_characters_32, new_characters_32: STRING_32
			i, j, count: INTEGER
		do
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
					str_32 := Text_russian_and_english.twin; str := str_32
					String_32.translate_deleting_null_characters (str_32, old_characters_32, new_characters_32, j = 2)
					str.translate_deleting_null_characters (old_characters, new_characters, j = 2)
					assert ("translate OK", str.to_unicode ~ str_32)
					j := j + 1
				end
				i := i + 1
			end
		end

feature -- Status query tests

	test_ends_with
		note
			testing: "covers/{ZSTRING}.ends_with", "covers/{ZSTRING}.remove_tail"
		local
			str_32, word_32: STRING_32; str, word: ZSTRING; i, count: INTEGER
		do
			str_32 := Text_russian_and_english.twin; str := str_32
			from i := Text_words.count until i = 0 loop
				word_32 := Text_words [i]; word := word_32
				if i = 1 then
					count := word.count
				else
					count := word.count + 1
				end
				assert ("ends_with OK", str.ends_with (word) = str_32.ends_with (word_32))
				str_32.remove_tail (count); str.remove_tail (count)
				assert ("remove_tail OK", str.to_unicode ~ str_32)
				i := i - 1
			end
		end

	test_for_all_split
		note
			testing: "covers/{ZSTRING}.for_all_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST
		do
			across Text_lines as line_32 loop
				line := line_32.item
				word_list := line
				assert ("word is in word_list", line.for_all_split (character_string (' '), agent word_list.has))
			end
		end

	test_has
		note
			testing: "covers/{ZSTRING}.has"
		local
			english: ZSTRING; english_32: STRING_32
		do
			english_32 := Text_lines.last
			english := english_32
			across Text_lines as line loop
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

	test_sort
		note
			testing: "covers/{ZSTRING}.is_less, covers/{ZSTRING}.str_strict_compare"
		local
			sorted: EL_SORTABLE_ARRAYED_LIST [ZSTRING]; sorted_32: EL_SORTABLE_ARRAYED_LIST [STRING_32]
			word: ZSTRING
		do
			create sorted.make (20); create sorted_32.make (20)
			sorted.compare_objects; sorted_32.compare_objects
			across Text_lines as line loop
				sorted.wipe_out; sorted_32.wipe_out
				across line.item.split (' ') as w loop
					word := w.item
					sorted.extend (word); sorted_32.extend (w.item)
				end
				sorted.sort; sorted_32.sort
				assert ("sorting OK", across sorted as l_a all l_a.item.to_unicode ~ sorted_32.i_th (l_a.cursor_index) end)
			end
		end

	test_starts_with
		note
			testing: "covers/{ZSTRING}.starts_with", "covers/{ZSTRING}.remove_head"
		local
			str_32, word_32: STRING_32; str, word: ZSTRING; pos_space: INTEGER
			done: BOOLEAN
		do
			across Text_lines as line loop
				str_32 := line.item.twin; str := str_32
				from done := False until done loop
					pos_space := str_32.index_of (' ', 1)
					if pos_space > 0 then
						word_32 := str_32.substring (1, pos_space)
					else
						word_32 := str_32
						done := True
					end
					word := word_32
					assert ("starts_with OK", str.starts_with (word) = str_32.starts_with (word_32))
					str_32.remove_head (word_32.count); str.remove_head (word.count)
					assert ("remove_head OK", str.to_unicode ~ str_32)
				end
			end
		end

	test_there_exists_split
		note
			testing: "covers/{ZSTRING}.there_exists_split"
		local
			line: ZSTRING; word_list: EL_ZSTRING_LIST
		do
			across Text_lines as line_32 loop
				line := line_32.item
				word_list := line
				across word_list as word loop
					assert ("word is in word_list", line.there_exists_split (character_string (' '), agent (word.item).is_equal))
				end
			end
		end

feature -- Removal tests

	test_remove
		note
			testing: "covers/{ZSTRING}.remove"
		local
			str_32: STRING_32; str: ZSTRING; i: INTEGER
		do
			across Text_words as word loop
				from i := 1 until i > word.item.count loop
					str_32 := word.item.twin; str := str_32
					str.remove (i); str_32.remove (i)
					assert ("remove OK", str.to_unicode ~ str_32)
					i := i + 1
				end
			end
		end

	test_remove_head
		note
			testing: "covers/{ZSTRING}.remove_head", "covers/{ZSTRING}.keep_tail"
		local
			str_32: STRING_32; str: ZSTRING; pos: INTEGER
		do
			str_32 := Text_russian_and_english.twin; str := str_32
			from until str_32.is_empty loop
				pos := str_32.index_of (' ', str_32.count)
				if pos > 0 then
					str_32.remove_head (pos); str.remove_head (pos)
				else
					str_32.remove_head (str_32.count) str.remove_head (str.count)
				end
				assert ("remove_head OK", str.to_unicode ~ str_32)
			end
		end

	test_remove_tail
		note
			testing: "covers/{ZSTRING}.remove_tail", "covers/{ZSTRING}.keep_head"
		local
			str_32: STRING_32; str: ZSTRING; pos: INTEGER
		do
			str_32 := Text_russian_and_english.twin; str := str_32
			from until str_32.is_empty loop
				pos := str_32.last_index_of (' ', str_32.count)
				if pos > 0 then
					str_32.remove_tail (pos); str.remove_tail (pos)
				else
					str_32.remove_tail (str_32.count) str.remove_tail (str.count)
				end
				assert ("remove_tail OK", str.to_unicode ~ str_32)
			end
		end

feature -- Access tests

	test_index_of
		note
			testing:	"covers/{ZSTRING}.index_of"
		local
			str: ZSTRING; str_32: STRING_32; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			across Text_lines as line loop
				str_32 := line.item; str := str_32
				across Text_characters as char loop
					uc := char.item
					across << 1, str_32.count // 2 >> as value loop
						i := value.item
						assert ("index_of OK", str.index_of (uc, i) = str_32.index_of (uc, i))
					end
				end
			end
		end

	test_last_index_of
		note
			testing:	"covers/{ZSTRING}.last_index_of"
		local
			str: ZSTRING; str_32: STRING_32; uc: CHARACTER_32
			index, index_32, i: INTEGER
		do
			across Text_lines as line loop
				str_32 := line.item; str := str_32
				across Text_characters as char loop
					uc := char.item
					across << str_32.count, str_32.count // 2 >> as value loop
						i := value.item
						assert ("last_index_of OK", str.last_index_of (uc, i) = str_32.last_index_of (uc, i))
					end
				end
			end
		end

	test_occurrences
		note
			testing:	"covers/{ZSTRING}.occurrences"
		local
			str: ZSTRING; str_32: STRING_32; uc: CHARACTER_32
		do
			across Text_lines as line loop
				str_32 := line.item; str := str_32
				across Text_characters as char loop
					uc := char.item
				end
				assert ("occurrences OK", str.occurrences (uc) ~ str_32.occurrences (uc))
			end
		end

	test_substring_index
		note
			testing: "covers/{ZSTRING}.substring, covers/{ZSTRING}.substring_index"
		local
			str, word, search_word: ZSTRING; str_32, word_32: STRING_32; pos, pos_32: INTEGER
		do
			across Text_lines as line loop
				str_32 := line.item; str := str_32
				across Text_words as search_word_32 loop
					search_word := search_word_32.item
					pos := str.substring_index (search_word, 1)
					pos_32 := str_32.substring_index (search_word_32.item, 1)
					assert ("substring_index OK", pos = pos_32)
					if pos_32 > 0 then
						word := str.substring (pos, pos + search_word.count - 1)
						word_32 := str_32.substring (pos_32, pos_32 + search_word_32.item.count - 1)
						assert ("substring_index OK", word.to_unicode ~ word_32)
					end
				end
			end
		end

	test_unicode_index_of
		note
			testing: "covers/{ZSTRING}.substring, covers/{ZSTRING}.index_of"
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
			str_32: STRING_32; str: ZSTRING
			i, count: INTEGER
		do
			str_32 := Text_russian_and_english; str := Text_russian_and_english
			count := str_32.count
			from i := 1 until (i + 4) > count loop
				assert ("substring OK",  str.substring (i, i + 4).to_unicode ~ str_32.substring (i, i + 4))
				i := i + 1
			end
		end

feature -- Escape tests

	test_bash_escape
		local
			bash_escaper: EL_BASH_PATH_ZSTRING_ESCAPER; bash_escaper_32: EL_BASH_PATH_STRING_32_ESCAPER
		do
			create bash_escaper.make; create bash_escaper_32.make
			escape_test ("BASH", bash_escaper, bash_escaper_32)
		end

	test_xml_escape
		local
			xml_escaper: EL_XML_ZSTRING_ESCAPER; xml_escaper_32: EL_XML_STRING_32_ESCAPER
		do
			create xml_escaper.make; create xml_escaper_32.make
			escape_test ("XML basic", xml_escaper, xml_escaper_32)

			create xml_escaper.make_128_plus; create xml_escaper_32.make_128_plus
			escape_test ("XML 128 plus", xml_escaper, xml_escaper_32)
		end

feature -- Unescape tests

	test_unescape
		note
			testing:	"covers/{ZSTRING}.unescape"
		local
			str: ZSTRING; str_32: STRING_32
			escape_table: EL_ZSTRING_UNESCAPER; escape_table_32: like new_escape_table
			escape_character: CHARACTER_32
		do
			across << ('\').to_character_32, 'л' >> as l_escape_character loop
				escape_character := l_escape_character.item
				create str_32.make (Text_russian_and_english.count)
				str_32.append_character (escape_character)
				str_32.append_character (escape_character)

				escape_table_32 := new_escape_table
				escape_table_32 [escape_character] := escape_character

				across Text_russian_and_english as character loop
					escape_table_32.search (character.item)
					if escape_table_32.found then
						str_32.append_character (escape_character)
					end
					str_32.append_character (character.item)
				end
				str_32 [str_32.index_of (' ', 1)] := escape_character
				str := str_32

				create escape_table.make (escape_character, escape_table_32)
				String_32.unescape (str_32, escape_character, escape_table_32)
				str.unescape (escape_table)
				assert ("unescape OK", str.to_unicode ~ str_32)
			end
		end

	test_substitution_marker_unescape
		note
			testing:	"covers/{ZSTRING}.unescape", "covers/{ZSTRING}.unescaped",
			 	"covers/{ZSTRING}.make_unescaped"
		local
			str: ZSTRING
		do
			str := "1 %%S 3"
			str.unescape (Substitution_mark_unescaper)
			assert ("has substitution marker", str.same_string ("1 %S 3"))
		end


feature {NONE} -- Implementation

	change_case (lower_32, upper_32: STRING_32)
		local
			lower, upper: ZSTRING
		do
			lower := lower_32; upper :=  upper_32
			assert ("to_upper OK", lower.as_upper.to_unicode ~ upper_32)
			assert ("to_lower OK", upper.as_lower.to_unicode ~ lower_32)
		end

	do_pruning_test (type: STRING)
		local
			str: ZSTRING; str_32: STRING_32
		do
			across Text_words as word loop
				str_32 := word.item; str := str_32
				across << Tab_character, Ogham_space_mark >> as c loop
					across 1 |..| 2 as n loop
						if type = Right_adjust or type = Prune_trailing then
							str_32.append_character (c.item)
						else
							str_32.prepend_character (c.item)
						end
						str := str_32
					end
					assert ("append_character OK", str.to_unicode ~ str_32)
					assert ("prepend_character OK", str.to_unicode ~ str_32)

					if type = Left_adjust then
						str.left_adjust; str_32.left_adjust
					elseif type = Right_adjust then
						str.right_adjust; str_32.right_adjust
					elseif type = Prune_trailing then
						str.prune_all_trailing (c.item); str_32.prune_all_trailing (c.item)
					end
					assert (type + " OK", str.to_unicode ~ str_32)
				end
			end
		end

	escape_test (name: STRING; escaper: EL_ZSTRING_ESCAPER; escaper_32: EL_STRING_32_ESCAPER)
		local
			str_32: STRING_32; str: ZSTRING
		do
			across << Text_russian_and_english, Vivalidi_title, Lower_case_characters >> as string loop
				str_32 := string.item.twin
				String_32.replace_character (str_32, '+', '&')
				str := str_32
				assert (name + " escape OK", escaper.escaped (str, False).to_unicode ~ escaper_32.escaped (str_32, False))
			end
		end

	new_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		do
			create Result.make (7)
			Result ['t'] := '%T'
			Result ['ь'] := 'в'
			Result ['и'] := 'N'
 		end

	test_concatenation (type: STRING)
		local
			str, substring: ZSTRING; str_32, substring_32: STRING_32; i, count: INTEGER
		do
			create str.make_empty; create str_32.make_empty
			count := (Text_russian_and_english.count // 5) * 5
			from i := 1 until i > count loop
				substring_32 := Text_russian_and_english.substring (i, i + 4)
				substring := substring_32
				if type ~ once "append" then
					str.append (substring);  str_32.append (substring_32)
				else
					str.prepend (substring);  str_32.prepend (substring_32)
				end
				assert (type + " OK", str.to_unicode ~ str_32)
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
			assert ("unicode_index_of OK", part_a.to_unicode ~ part_32)
		end

feature {NONE} -- String 8 constants

	Left_adjust: STRING = "left_adjust"

	Right_adjust: STRING = "right_right"

	Prune_leading: STRING = "prune_leading"

	Prune_trailing: STRING = "prune_trailing"

feature {NONE} -- Constants

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		local
			table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create table.make_equal (3)
			table ['S'] := '%S'
			create Result.make ('%%', table)
		end
end
