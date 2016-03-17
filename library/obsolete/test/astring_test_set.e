note
	description: "[
		Tests for classes EL_ASTRING and EL_FILE_LINE_SOURCE
	]"

	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:58:57 GMT (Wednesday 16th December 2015)"
	revision: "7"

class
	ASTRING_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as eqa_file_system
		end

	EL_SHARED_CODEC
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

feature -- EL_FILE_LINE_SOURCE tests

	test_read_text_lines
			-- New test routine
		note
			testing: "covers/{EL_FILE_LINE_SOURCE}"
		local
			lines: EL_FILE_LINE_SOURCE
			expected_interval, lines_interval: INTEGER_INTERVAL
			path_list: EL_FILE_PATH_LIST
		do
			path_list := new_text_files_list
			across path_list as path loop
				create expected_interval.make (1, path.cursor_index - 1)
				create lines_interval.make (1, 0)
				create lines.make (path.item)
				across lines as line loop
					lines_interval.extend (line.item.to_integer)
				end
				assert ("intervals equal", expected_interval ~ lines_interval)
			end

			-- Clean up
			across path_list as path loop
				File_system.remove_file (path.item)
			end
		end

feature -- EL_ASTRING tests

	ISO_8859_15_tests
		local
			l_codec: EL_CODEC
		do
			l_codec := system_codec
			set_system_codec (create {EL_ISO_8859_15_CODEC}.make)

			test_append_string
			test_append_unicode
			test_append_unicode_general
			test_case_changing
			test_left_right_adjustments
			test_make_from_unicode
			test_over_extend
			test_prepend
			test_proper_case
			test_remove_head
			test_remove_tail
			test_same_string
			test_substring
			test_substring_index
			test_unicode_index_of
			test_unicode_split

			set_system_codec (l_codec)
		end

	test_append_string
		local
			str_32: STRING_32; a: EL_ASTRING
		do
			create str_32.make_empty; create a.make_empty
			across Russian_proverb_words as word loop
				if not str_32.is_empty then
					str_32.append_character (' '); a.append_character (' ')
				end
				str_32.append (word.item)
				a.append (create {EL_ASTRING}.make_from_unicode (word.item))
				assert ("append_string OK", a.to_unicode ~ str_32)
			end
		end

	test_append_unicode
		local
			a: EL_ASTRING
		do
			create a.make_empty
			across Russian_eat_a_fish_proverb as uc loop
				a.append_unicode (uc.item.natural_32_code)
			end
			assert ("append_unicode OK", a.to_unicode ~ Russian_eat_a_fish_proverb)
		end

	test_append_unicode_general
		local
			str_32: STRING_32 a: EL_ASTRING
		do
			create str_32.make_empty; create a.make_empty
			across Russian_proverb_words as word loop
				if not str_32.is_empty then
					str_32.append_character (' '); a.append_character (' ')
				end
				str_32.append (word.item)
				a.append_unicode_general (word.item)
				assert ("append_unicode_general OK", a.to_unicode ~ str_32)
			end
		end

	test_case_changing
		local
			l, u: STRING_32
		do
			l := Lower_case
			u := l.as_upper
			change_case (Lower_case, Upper_case)
			change_case (Italian_business, Italian_business_upper)
			change_case (Russian_eat_a_fish_proverb, Russian_eat_a_fish_proverb_upper)
--			change_case (Lower_case_mu, Upper_case_mu)
		end

	test_ends_with
		note
			testing: "covers/{EL_ASTRING}.ends_with", "covers/{EL_ASTRING}.remove_tail"
		local
			str_32: STRING_32; str, word: EL_ASTRING; pos: INTEGER
		do
			str_32 := Russian_eat_a_fish_proverb.twin
			str := Russian_eat_a_fish_proverb
			across Russian_proverb_words as word_32 loop
				word := word_32.item
				assert ("ends_with OK", str.ends_with (word) = str_32.ends_with (word_32.item))
				str_32.remove_tail (word_32.item.count)
				str.remove_tail (word.count)
				if not str_32.is_empty then
					str_32.remove_tail (1)
					str.remove_tail (1)
				end
				assert ("ends_with OK", str.ends_with (word) = str_32.ends_with (word_32.item))
			end
		end

	test_has
		note
			testing:	"covers/{EL_ASTRING}.has"
		local
			str: EL_ASTRING
		do
			str := Tao
			assert ("has each letter", across Tao as uc all str.has (uc.item) end)
			assert ("not has X", not str.has ('X'))
			assert ("not has trademark symbol", not str.has ({CHARACTER_32} '™'))
		end

	test_index_of
		note
			testing: "covers/{EL_ASTRING}.index_of"
		local
			characters, uc_proverb: STRING_32; proverb: EL_ASTRING
			i: INTEGER; c: CHARACTER_32
		do
			characters := Tao + Russian_water
			uc_proverb := Russian_eat_a_fish_proverb
			proverb := Russian_eat_a_fish_proverb
			from i := 1 until i > characters.count loop
				c := characters [i]
				assert ("same index", uc_proverb.index_of (c, 1) = proverb.index_of (c, 1))
				i := i + 1
			end
		end

	test_insert_string
		note
			testing:	"covers/{EL_ASTRING}.insert_string"
		local
			uc_incomplete_proverb: STRING_32
			incomplete_proverb, word: EL_ASTRING
			pos_word: INTEGER
		do
			across Russian_proverb_words as uc_word loop
				pos_word := Russian_eat_a_fish_proverb.substring_index (uc_word.item, 1)
				uc_incomplete_proverb := Russian_eat_a_fish_proverb.substring (1, pos_word - 1)
				uc_incomplete_proverb.append (
					Russian_eat_a_fish_proverb.substring (pos_word + uc_word.item.count, Russian_eat_a_fish_proverb.count)
				)
				incomplete_proverb := uc_incomplete_proverb
				word := uc_word.item
				incomplete_proverb.insert_string (word, pos_word)
				assert ("insertion correct", incomplete_proverb.to_unicode ~ Russian_eat_a_fish_proverb)
			end
		end

	test_left_right_adjustments
		note
			testing:	"covers/{EL_ASTRING}.left_adjust", "covers/{EL_ASTRING}.right_adjust"
		local
			str: EL_ASTRING; str_32, white_space, white_space_32: STRING_32
		do
			across Russian_proverb_words as word loop
				create white_space_32.make_empty
				str := word.item; str_32 := word.item.twin
				across << Tab_character, Ogham_space_mark >> as c loop
					adjust (str, str_32, True); adjust (str, str_32, False)
					white_space_32.append_character (c.item)
					white_space := white_space_32
					str.append (white_space); str_32.append (white_space_32)
				end
				adjust (str, str_32, True); adjust (str, str_32, False)
			end
		end

	test_make_from_unicode
		note
			testing:	"covers/{EL_ASTRING}.make_from_unicode", "covers/{EL_ASTRING}.to_unicode"
		local
			str: EL_ASTRING
		do
			across << Italian_business, Russian_eat_a_fish_proverb, Persian_eat_a_fish_proverb, Trademark, Tao >> as str_32 loop
				str := str_32.item
				assert ("unicode correct", str.to_unicode ~ str_32.item)
			end
		end

	test_over_extend
		local
			proverb: EL_ASTRING
		do
			proverb := Russian_eat_a_fish_proverb
			proverb.append_unicode_general (Persian_eat_a_fish_proverb)
			assert ("has_unencoded_characters OK", proverb.has_unencoded_characters)
			assert ("Has 3 unencoded characters", proverb.to_unicode.occurrences ('�') = 2)
		end

	test_prepend
		local
			str_32: STRING_32; str, word: EL_ASTRING
			use_prepend_routine: BOOLEAN
			space: STRING
		do
			space := " "
			create str_32.make_empty; create str.make_empty
			across Russian_proverb_words as word_32 loop
				if not str_32.is_empty then
					str_32.prepend_string_general (space); str.prepend_string (space)
				end
				str_32.prepend (word_32.item)
				word := word_32.item
				str.prepend (word)
				assert ("prepend OK", str.to_unicode ~ str_32)
			end
		end

	test_proper_case
		local
			str: EL_ASTRING
		do
			str := Italian_business_upper
			assert ("propercase OK", str.as_proper_case.to_unicode ~ Italian_business_propercase)
		end

	test_put_unicode
		note
			testing:	"covers/{EL_ASTRING}.make_from_unicode", "covers/{EL_ASTRING}.put_unicode"
		local
			str: EL_ASTRING; str_32: STRING_32; i: INTEGER
		do
			str := Tao; str_32 := Tao.twin
			from i := 1 until i > Tao.count loop
				str.put_unicode (Trademark_sign.natural_32_code, i)
				str_32.put_code (Trademark_sign.natural_32_code, i)
				assert ("same strings", str.to_unicode ~ str_32)
				i := i + 1
			end
		end

	test_remove_head
		local
			str_32: STRING_32
			str: EL_ASTRING
			pos: INTEGER
		do
			str_32 := Russian_eat_a_fish_proverb.twin
			str := Russian_eat_a_fish_proverb
			from until str_32.is_empty loop
				pos := str_32.index_of (' ', 1)
				if pos > 0 then
					str_32.remove_head (pos); str.remove_head (pos)
				else
					str_32.remove_head (str_32.count) str.remove_head (str.count)
				end
				assert ("remove_head OK", str.to_unicode ~ str_32)
			end
		end

	test_remove_tail
		local
			str_32: STRING_32
			str: EL_ASTRING
			pos: INTEGER
		do
			str_32 := Russian_eat_a_fish_proverb.twin
			str := Russian_eat_a_fish_proverb
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

	test_replace_character
		note
			testing:	"covers/{EL_ASTRING}.make_from_unicode",
						"covers/{EL_ASTRING}.replace_character"
		local
			str: EL_ASTRING; str_32: STRING_32; i, j: INTEGER
			uc: CHARACTER_32
		do
			str := Tao; str_32 := Tao.twin
			from i := 1 until i = 4 loop
				uc := str_32 [i]
				str.replace_character (uc, Trademark_sign)
				from j := 1 until j > str_32.count loop
					if str_32 [j] = uc then
						str_32 [j] := Trademark_sign
					end
					j := j + 1
				end
				assert ("same strings", str.to_unicode ~ str_32)
				i := i + 1
			end
		end

	test_replace_substring
		note
			testing:	"covers/{EL_ASTRING}.make_from_unicode", "covers/{EL_ASTRING}.replace_substring",
						"covers/{EL_ASTRING}.substring_index"
		local
			str: EL_ASTRING; str_32, replacement: STRING_32
			index: INTEGER
		do
			from replacement := Tao.twin until replacement.count = 1 loop
				across Russian_proverb_words as word loop
					str_32 := Russian_eat_a_fish_proverb.twin
					str := Russian_eat_a_fish_proverb
					index := str_32.substring_index (word.item, 1)
					str_32.replace_substring (replacement, index, index + word.item.count - 1)
					str.replace_substring (replacement, index, index + word.item.count - 1)
					assert ("same strings", str.to_unicode ~ str_32)
				end
				replacement.remove_head (1)
				replacement.remove_tail (1)
			end
		end

	test_replace_substring_all
		local
			target_32, old_target_32: STRING_32; target, old_target: EL_ASTRING
			c, letter: CHARACTER_32
			table: HASH_TABLE [STRING_32, STRING_32]
			original, new: STRING_32; original_32, new_32: STRING_32
		do
			create target_32.make (Russian_eat_a_fish_proverb.count * 2 + 1)
			across 1 |..| 2 as index loop
				across Russian_eat_a_fish_proverb.split ('%N') as line loop
					if not target_32.is_empty then
						target_32.append_character (' ')
					end
					target_32.append_string (line.item)
				end
			end
			target := target_32; old_target := target_32
			old_target_32 := target_32.twin
			create table.make_equal (20)
			letter := 'A'
			across Russian_proverb_words as word loop
				original := word.item
				table.search (original)
				if table.found then
					new := table.found_item
				else
					create new.make_filled (letter, 1)
					letter := letter + 1
					table.put (new, original)
				end
				target.replace_substring_all (original, new)
				target_32.replace_substring_all (original, new)
				assert ("same strings", target.to_unicode ~ target_32)
			end
			across table as word loop
				new := word.key; original := word.item
				target.replace_substring_all (original, new)
				target_32.replace_substring_all (original, new)
				assert ("same strings", target.to_unicode ~ target_32)
			end
			assert ("same as old target", target ~ old_target)
			assert ("same as old target_32", target_32 ~ old_target_32)
		end

	test_same_string
		local
			a, b: EL_ASTRING
		do
			a := Russian_eat_a_fish_proverb
			b := Russian_eat_a_fish_proverb
			assert ("a same string as b", a.same_string (b))
		end

	test_sort
		local
			sorted: SORTED_TWO_WAY_LIST [EL_ASTRING]; sorted_32: SORTED_TWO_WAY_LIST [STRING_32]
			word: EL_ASTRING
		do
			create sorted.make; create sorted_32.make
			sorted.compare_objects; sorted_32.compare_objects
			across Russian_proverb_words as w loop
				word := w.item
				sorted.extend (word); sorted_32.extend (w.item)
			end
			sorted.sort; sorted_32.sort
			assert ("sorting OK", across sorted as l_a all l_a.item.to_unicode ~ sorted_32.i_th (l_a.cursor_index) end)
		end

	test_starts_with
		note
			testing: "covers/{EL_ASTRING}.starts_with"
		local
			str_32: STRING_32; str, word: EL_ASTRING; pos: INTEGER
		do
			str_32 := Russian_eat_a_fish_proverb.twin
			str := Russian_eat_a_fish_proverb
			across str_32.split (' ') as word_32 loop
				word := word_32.item
				assert ("starts_with OK", str.starts_with (word) = str_32.starts_with (word_32.item))
				str_32.remove_head (word_32.item.count)
				str.remove_head (word.count)
				if not str_32.is_empty then
					str_32.remove_head (1)
					str.remove_head (1)
				end
				assert ("starts_with OK", str.starts_with (word) = str_32.starts_with (word_32.item))
			end
		end

	test_substring
		local
			a, b: EL_ASTRING
		do
			a := Upper_case
			assert ("Upper substring OK", a.substring (2, a.count).to_unicode ~ Upper_case.substring (2, Upper_case.count))

			a := Italian_business
			b := Italian_business
			b.remove_tail (5)
			assert ("substring OK", a.substring (1, a.count - 5) ~ b)
		end

	test_substring_index
		local
			str, word: EL_ASTRING; word32: STRING_32; pos: INTEGER
		do
			str := Russian_eat_a_fish_proverb
			across Russian_proverb_words as search_word loop
				pos := str.substring_index (search_word.item, 1)
				word := str.substring (pos, pos + search_word.item.count - 1)

				pos := Russian_eat_a_fish_proverb.substring_index (search_word.item, 1)
				word32 := Russian_eat_a_fish_proverb.substring (pos, pos + search_word.item.count - 1)
				assert ("found substring OK", word.to_unicode ~ word32)
			end
		end

	test_unescape
		note
			testing:	"covers/{EL_ASTRING}.make_from_unicode", "covers/{EL_ASTRING}.unescape",
						"covers/{EL_ASTRING}.put_unicode"
		local
			escaped: EL_ASTRING
		do
			escaped := C_escaped
			escaped.unescape (C_escape_character, C_escape_table)
			assert ("escaped correctly", escaped.to_unicode ~ C_unescaped)
		end

	test_unicode_index_of
		do
			across << (' ').to_character_32, 'и' >> as c loop
				unicode_index_of (Russian_eat_a_fish_proverb, c.item)
			end
			unicode_index_of (Italian_business, '´')
		end

	test_unicode_split
		do
			across << (' ').to_character_32, 'и' >> as separator loop
				unicode_split (Russian_eat_a_fish_proverb, separator.item)
			end
			unicode_split (Italian_business, '´')
		end

	test_word_search (str_32: STRING_32)
		local
			str: EL_ASTRING
			pos: INTEGER
		do
			str := str_32
			pos := 1
			across str.split (' ') as word loop
				pos := str.substring_index (word.item, 1)
				assert ("word found EL_ASTRING", str.substring (pos, pos + word.item.count - 1) ~ word.item)
				assert ("word found STRING_32", str_32.substring (pos, pos + word.item.count - 1) ~ word.item.to_unicode)
			end
		end

feature -- EL_DIR_PATH tests

	test_parent
		note
			testing:	"covers/{EL_PATH}.parent"
		local
			dir_path: EL_DIR_PATH
		do
			dir_path := "/Music/genre"
			dir_path := dir_path.parent
			assert ("parent is /Music", dir_path.to_string.same_string ("/Music"))
			assert ("/Music has parent", dir_path.has_parent)
			dir_path := dir_path.parent
			assert ("/ has no parent", not dir_path.has_parent)
			assert ("parent is /", dir_path.to_string.same_string ("/"))
		end

feature {NONE} -- Implementation

	adjust (str: EL_ASTRING; str_32: STRING_32; left: BOOLEAN)
		do
			if left then
				str.left_adjust; str_32.left_adjust
			else
				str.right_adjust; str_32.right_adjust
			end
			assert ("same string", str.to_unicode ~ str_32)
		end

	change_case (a_lower, a_upper: STRING_32)
		local
			lower, upper: EL_ASTRING
		do
			lower := a_lower
			assert ("To upper conversion OK", lower.as_upper.to_unicode ~ a_upper)
			upper :=  a_upper
			assert ("To lower conversion OK", upper.as_lower.to_unicode ~ a_lower)
		end

	new_text_files_list: EL_FILE_PATH_LIST
		local
			file: PLAIN_TEXT_FILE
			path: EL_FILE_PATH
		do
			create Result.make_empty
			across 0 |..| Max_count as count loop
				Result.extend ((Template #$ [count.item]).to_unicode)
				create file.make_open_write (Result.last_path)
				across 1 |..| count.item as line loop
					if line.item > 1 then
						file.put_new_line
					end
					file.put_integer (line.item)
				end
				file.close
			end
		end

	unicode_index_of (str_32: STRING_32; uc: CHARACTER_32)
		local
			str, part_a: EL_ASTRING; part_32: STRING_32
		do
			str := str_32
			part_a := str.substring (1, str.index_of (uc, 1))
			part_32 := str_32.substring (1, str_32.index_of (uc, 1))
			assert ("unicode_index_of OK", part_a.to_unicode ~ part_32)
		end

	unicode_split (a_str_32: STRING_32; a_separator: CHARACTER_32)
		local
			str: EL_ASTRING; strings_a: LIST [EL_ASTRING]; strings_32: LIST [STRING_32]
			ok: BOOLEAN
		do
			str := a_str_32
			strings_a := str.unicode_split (a_separator)
			strings_32 := a_str_32.split (a_separator)
			ok := strings_a.count = strings_32.count
						and then across strings_a as s all s.item.to_unicode ~ strings_32.i_th (s.cursor_index) end
			assert ("unicode_split OK", ok)
		end

feature {NONE} -- Character contants

	C_escape_character: CHARACTER_32 = '\'

	Ogham_space_mark: CHARACTER_32
		once
			Result := (1680).to_character_32
		end

	Tab_character: CHARACTER_32
		once
			Result := '%T'
		end

	Tao_sign: CHARACTER_32 = '࿊'

	Trademark_sign: CHARACTER_32 = '™'

feature {NONE} -- String_32 contants

	C_escaped: STRING_32 = "\\не\лезт\ь\nwanting\t"

	C_unescaped: STRING_32 = "\не\лезтb%Nwanting%T"

	Italian_business: STRING_32 = "€un´attivitá"

	Italian_business_propercase: STRING_32 = "€Un´Attivitá"

	Italian_business_upper: STRING_32 = "€UN´ATTIVITÁ"

	Lower_case: STRING_32 = "™ÿaàöžšœ" --

	Lower_case_mu: STRING_32 = "µ symbol"

	Persian_eat_a_fish_proverb: STRING_32 = "هم خر را خواستن و هم خرما را‎"

	Russian_eat_a_fish_proverb: STRING_32 = "и рыбку съесть, и в воду не лезть%Nwanting to eat a fish without first catching it from the waters"

	Russian_eat_a_fish_proverb_upper: STRING_32 = "И РЫБКУ СЪЕСТЬ, И В ВОДУ НЕ ЛЕЗТЬ%NWANTING TO EAT A FISH WITHOUT FIRST CATCHING IT FROM THE WATERS"

	Russian_water: STRING_32 = "воду"

	Tao: STRING_32 = "࿊Tao࿊"

	Trademark: STRING_32 = "™Trade™"

	Upper_case: STRING_32 = "™ŸAÀÖŽŠŒ"

	Upper_case_mu: STRING_32 = "Μ SYMBOL"

feature {NONE} -- Constants

	C_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (7)
			Result [C_escape_character] := C_escape_character
			Result ['t'] := '%T'
			Result ['n'] := '%N'
			Result ['ь'] := 'b'
		end

	Russian_proverb_words: ARRAYED_LIST [STRING_32]
		once
			create Result.make (50)
			across Russian_eat_a_fish_proverb.split ('%N') as line loop
				across line.item.split (' ') as word loop
					Result.extend (word.item)
				end
			end
		end

	Max_count: INTEGER = 3

	Template: EL_ASTRING
		once
			Result := "lines-$S.txt"
		end

end


