note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"

	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:28:55 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	TEST_EL_ASTRING

inherit
	EQA_TEST_SET

	EL_SHARED_CODEC
		undefine
			default_create
		end

feature -- Test routines

	ISO_8859_1_tests
		local
			l_codec: EL_CODEC
		do
			l_codec := codec
			set_codec (create {EL_ISO_8859_1_CODEC}.make)

			test_adjustments
			test_append_string
			test_append_unicode
			test_append_unicode_general
			test_case_changing
			test_make_from_unicode
			test_over_extend
			test_prepend
			test_proper_case
			test_remove_head
			test_remove_tail
			test_same_string
			test_string_search
			test_substring
			test_substring_and_substring_index
			test_unicode_index_of
			test_unicode_split

			set_codec (l_codec)
		end

	test_string_search
			-- New test routine
		note
			testing:  "covers/{EL_STRING_SEARCHER}.substring_index_with_deltas",
			          "covers/{EL_OCCURRENCE_SUBSTRINGS}.make",
			          "covers/{EL_ASTRING}.substring",
			          "covers/{EL_ASTRING}.append_unicode"
		local
			substrings: EL_OCCURRENCE_SUBSTRINGS
			str, search_str, substring: EL_ASTRING
			count: INTEGER
		do
			create str.make_empty
			across 1 |..| 3 as i loop
				str.append_unicode_general (Tao)
				str.append_unicode_general (Trademark)
			end
			assert ("append OK", str.to_unicode ~ Tao + Trademark + Tao + Trademark + Tao + Trademark)
			search_str := Trademark
			search_str.remove_tail (2)
			create substrings.make (str, search_str)
			from substrings.start until substrings.after loop
				substring := str.substring (substrings.item_for_iteration.lower, substrings.item_for_iteration.upper)
				assert ("substring found", substring ~ search_str)
				count := count + 1
				substrings.forth
			end
			assert ("Three occurrences", count = 3)

			test_word_search (Russian_eat_a_fish_proverb)
		end

	test_word_search (a_str: STRING_32)
		local
			s: EL_ASTRING
			pos: INTEGER
		do
			s := a_str
			pos := 1
			across s.split (' ') as word loop
				pos := s.substring_index (word.item, 1)
				assert ("word found EL_ASTRING", s.substring (pos, pos + word.item.count - 1) ~ word.item)
				assert ("word found STRING_32", a_str.substring (pos, pos + word.item.count - 1) ~ word.item.to_unicode)
			end
		end

	test_adjustments
		note
			testing:	"covers/{EL_ASTRING}.left_adjust",
						"covers/{EL_ASTRING}.right_adjust"
		local
			s: EL_ASTRING
		do
			s := Trademark
			s.left_adjust
			s.right_adjust
			assert ("Same as before", s ~ Trademark)
			s.prepend_character ('%T')
			s.append_character ('%T')
			s.left_adjust
			s.right_adjust
			assert ("Same as before", s ~ Trademark)
		end

	test_make_from_unicode
		note
			testing:	"covers/{EL_ASTRING}.make_from_unicode",
						"covers/{EL_ASTRING}.to_unicode"
		local
			s: EL_ASTRING
		do
			across << Italian_business, Russian_eat_a_fish_proverb, Persian_eat_a_fish_proverb, Trademark, Tao >> as str loop
				s := str.item
				assert ("unicode correct", s.to_unicode ~ str.item)
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

	test_substring_and_substring_index
		local
			s, word: EL_ASTRING
			word32: STRING_32
			pos: INTEGER
		do
			s := Russian_eat_a_fish_proverb
			across Russian_eat_a_fish_proverb.split (' ') as search_word loop
				pos := s.substring_index (search_word.item, 1)
				word := s.substring (pos, pos + search_word.item.count - 1)

				pos := Russian_eat_a_fish_proverb.substring_index (search_word.item, 1)
				word32 := Russian_eat_a_fish_proverb.substring (pos, pos + search_word.item.count - 1)
				assert ("found substring OK", word.to_unicode ~ word32)
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

	test_same_string
		local
			a, b: EL_ASTRING
		do
			a := Russian_eat_a_fish_proverb
			b := Russian_eat_a_fish_proverb
			assert ("a same string as b", a.same_string (b))
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

	test_remove_head
		local
			s: STRING_32
			a: EL_ASTRING
			pos: INTEGER
		do
			s := Russian_eat_a_fish_proverb.twin
			a := Russian_eat_a_fish_proverb
			from until s.is_empty loop
				pos := s.index_of (' ', 1)
				if pos > 0 then
					s.remove_head (pos); a.remove_head (pos)
				else
					s.remove_head (s.count) a.remove_head (a.count)
				end
				assert ("remove_head OK", a.to_unicode ~ s)
			end
		end

	test_remove_tail
		local
			s: STRING_32
			a: EL_ASTRING
			pos: INTEGER
		do
			s := Russian_eat_a_fish_proverb.twin
			a := Russian_eat_a_fish_proverb
			from until s.is_empty loop
				pos := s.last_index_of (' ', s.count)
				if pos > 0 then
					s.remove_tail (pos); a.remove_tail (pos)
				else
					s.remove_tail (s.count) a.remove_tail (a.count)
				end
				assert ("remove_tail OK", a.to_unicode ~ s)
			end
		end

	test_append_unicode_general
		local
			s: STRING_32
			a: EL_ASTRING
		do
			create s.make_empty; create a.make_empty
			across Russian_eat_a_fish_proverb.split (' ') as word loop
				if not s.is_empty then
					s.append_character (' '); a.append_character (' ')
				end
				s.append (word.item)
				a.append_unicode_general (word.item)
				assert ("append_unicode_general OK", a.to_unicode ~ s)
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

	test_append_string
		local
			s: STRING_32
			a: EL_ASTRING
		do
			create s.make_empty; create a.make_empty
			across Russian_eat_a_fish_proverb.split (' ') as word loop
				if not s.is_empty then
					s.append_character (' '); a.append_character (' ')
				end
				s.append (word.item)
				a.append (create {EL_ASTRING}.make_from_unicode (word.item))
				assert ("append_string OK", a.to_unicode ~ s)
			end
		end

	test_prepend
		local
			s: STRING_32
			a: EL_ASTRING
		do
			create s.make_empty; create a.make_empty
			across Russian_eat_a_fish_proverb.split (' ') as word loop
				if not s.is_empty then
					s.prepend_character (' '); a.prepend_character (' ')
				end
				s.prepend (word.item)
				a.prepend (create {EL_ASTRING}.make_from_unicode (word.item))
				assert ("prepend OK", a.to_unicode ~ s)
			end
		end

	test_unicode_split
		do
			across << (' ').to_character_32, 'и' >> as separator loop
				unicode_split (Russian_eat_a_fish_proverb, separator.item)
			end
			unicode_split (Italian_business, '´')
		end

	test_unicode_index_of
		do
			across << (' ').to_character_32, 'и' >> as c loop
				unicode_index_of (Russian_eat_a_fish_proverb, c.item)
			end
			unicode_index_of (Italian_business, '´')
		end

	test_sort
		local
			sorted_a: SORTED_TWO_WAY_LIST [EL_ASTRING]
			a: EL_ASTRING
			sorted_32: SORTED_TWO_WAY_LIST [STRING_32]
		do
			create sorted_a.make
			sorted_a.compare_objects
			a := Russian_eat_a_fish_proverb
			sorted_a.append (a.split (' '))
			sorted_a.sort

			create sorted_32.make
			sorted_32.compare_objects
			sorted_32.append (Russian_eat_a_fish_proverb.split (' '))
			sorted_32.sort

			assert ("sorting OK", across sorted_a as l_a all l_a.item.to_unicode ~ sorted_32.i_th (l_a.cursor_index) end)
		end

	test_proper_case
		local
			str: EL_ASTRING
		do
			str := Italian_business_upper
			assert ("propercase OK", str.as_proper_case.to_unicode ~ Italian_business_propercase)
		end

feature {NONE} -- Implementation

	unicode_index_of (str: STRING_32; uc: CHARACTER_32)
		local
			a: EL_ASTRING
			part_a: EL_ASTRING
			part_32: STRING_32
		do
			a := str
			part_a := a.substring (1, a.index_of_unicode (uc, 1))
			part_32 := str.substring (1, str.index_of (uc, 1))
			assert ("unicode_index_of OK", part_a.to_unicode ~ part_32)
		end

	unicode_split (str: STRING_32; a_separator: CHARACTER_32)
		local
			a: EL_ASTRING
			strings_a: LIST [EL_ASTRING]
			strings_32: LIST [STRING_32]
		do
			a := str
			strings_a := a.unicode_split (a_separator)
			strings_32 := str.split (a_separator)
			assert (
				"unicode_split OK",
				strings_a.count = strings_32.count
					and then across strings_a as s all s.item.to_unicode ~ strings_32.i_th (s.cursor_index) end
			)
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

feature {NONE} -- Constants

	Russian_eat_a_fish_proverb: STRING_32 = "и рыбку съесть, и в воду не лезть%Nwanting to eat a fish without first catching it from the waters"

	Russian_eat_a_fish_proverb_upper: STRING_32 = "И РЫБКУ СЪЕСТЬ, И В ВОДУ НЕ ЛЕЗТЬ%NWANTING TO EAT A FISH WITHOUT FIRST CATCHING IT FROM THE WATERS"

	Persian_eat_a_fish_proverb: STRING_32 = "هم خر را خواستن و هم خرما را‎"

	Russian_water: STRING_32 = "воду"

	Trademark: STRING_32 = "™Trade™"

	Tao: STRING_32 = "࿊Tao࿊"

	Italian_business: STRING_32 = "€un´attivitá"

	Italian_business_upper: STRING_32 = "€UN´ATTIVITÁ"

	Italian_business_propercase: STRING_32 = "€Un´Attivitá"

	Lower_case: STRING_32 = "™ÿaàöžšœ" --

	Upper_case: STRING_32 = "™ŸAÀÖŽŠŒ" --

	Lower_case_mu: STRING_32 = "µ symbol"

	Upper_case_mu: STRING_32 = "Μ SYMBOL"
end

