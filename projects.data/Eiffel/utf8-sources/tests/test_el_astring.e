note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"

	testing: "type/manual"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-17 10:02:25 GMT (Wednesday 17th July 2013)"
	revision: "2"

class
	TEST_EL_ASTRING

inherit
	EQA_TEST_SET

	EL_SHARED_CODEC
		undefine
			default_create
		end

feature -- Test routines

	test_ISO_8859_1_codec
		local
			l_codec: EL_CODEC
		do
			l_codec := codec
			set_codec (create {EL_ISO_8859_1_CODEC}.make)

			test_string_search
			test_adjustments
			test_make_from_unicode
			test_substring
			test_substring_and_search
			test_case_changing
			test_russian

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
						"covers/{EL_ASTRING}.unicode"
		local
			s: EL_ASTRING
		do
			s := Italian_business
			assert ("unicode correct", s.to_unicode ~ Italian_business)
		end

	test_special_arrays
		local
			a, b: SPECIAL [CHARACTER]
		do
			create a.make_filled ('1', 1)
			create b.make_empty (10)
			b.extend ('1')
			assert ("a equals b", a ~ b)
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

	test_substring_and_search
		local
			s, search_str, found_str: EL_ASTRING
			pos: INTEGER
		do
			s := Russian_eat_a_fish_proverb
			search_str := Russian_water
			pos := s.substring_index (search_str, 1)
			found_str := s.substring (pos, pos + search_str.count - 1)
			assert ("found substring OK", found_str.to_unicode ~ Russian_water)
		end

	test_case_changing
		do
			change_case (Lower_case, Upper_case)
			change_case (Italian_business, Italian_business_upper)
			change_case (Russian_eat_a_fish_proverb, Russian_eat_a_fish_proverb_upper)
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

	test_russian
		local
			a, b: EL_ASTRING
		do
			a := Russian_eat_a_fish_proverb
			b := Russian_eat_a_fish_proverb
			assert ("a equals b", a ~ b)
			assert ("unicode conversion OK", a.to_unicode ~ Russian_eat_a_fish_proverb)
		end

feature {NONE} -- Constants

	Russian_eat_a_fish_proverb: STRING_32 = "и рыбку съесть, и в воду не лезть – wanting to eat a fish without first catching it from the waters"

	Russian_eat_a_fish_proverb_upper: STRING_32 = "И РЫБКУ СЪЕСТЬ, И В ВОДУ НЕ ЛЕЗТЬ – WANTING TO EAT A FISH WITHOUT FIRST CATCHING IT FROM THE WATERS"

	Russian_water: STRING_32 = "воду"

	Trademark: STRING_32 = "™Trade™"

	Tao: STRING_32 = "࿊Tao࿊"

	Italian_business: STRING_32 = "€un´attivitá"

	Italian_business_upper: STRING_32 = "€UN´ATTIVITÁ"

	Lower_case: STRING_32 = "™ÿaàöžšœ"

	Upper_case: STRING_32 = "™ŸAÀÖŽŠŒ"
end


