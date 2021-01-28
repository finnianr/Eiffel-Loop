note
	description: "[
		Usually referenced with the alias 'ZSTRING', this string is a memory efficient alternative to using `STRING_32'.
		When an application mainly uses characters from the ISO-8859-15 character set, the memory saving can be as much as 70%,
		while the execution efficiency is roughly the same as for `STRING_8'. For short strings the saving is much less:
		about 50%. ISO-8859-15 covers most Western european languages.
	]"
	tests: "Class [$source ZSTRING_TEST_SET]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-28 10:13:33 GMT (Thursday 28th January 2021)"
	revision: "33"

class
	EL_ZSTRING

inherit
	EL_READABLE_ZSTRING
		rename
			append_string_8 as append_raw_string_8
		export
			{ANY}
--			Element change
			append_boolean, append_character,

			append_double, append_real, append_integer, append_natural,
			append_real_32, append_real_64,
			append_integer_8, append_integer_16, append_integer_32, append_integer_64,
			append_natural_8, append_natural_16, append_natural_32, append_natural_64,

			append_raw_string_8, append_string, append, append_string_general, append_substring,
			append_unicode, append_tuple_item, append_utf_8,
			extend, enclose, fill_character, multiply,

			prepend_boolean, prepend_character, prepend_integer, prepend_integer_32,
			prepend_real_32, prepend_real, prepend_real_64, prepend_double, prepend_substring,

			precede, put_unicode, quote,
			translate, translate_general,
--			Transformation
			mirror, replace_character, replace_delimited_substring, replace_delimited_substring_general,
			replace_substring, replace_substring_all, replace_substring_general, replace_substring_general_all,
			to_canonically_spaced, to_lower, to_proper_case, to_upper, translate_deleting_null_characters,
			unescape,
--			Removal
			keep_head, keep_tail, left_adjust, remove_head, remove_tail, right_adjust
		end

	EL_WRITEABLE
		rename
			write_raw_character_8 as append_raw_character_8,
			write_character_8 as append_character_8,
			write_character_32 as append_character,
			write_integer_8 as append_integer_8,
			write_integer_16 as append_integer_16,
			write_integer_32 as append_integer,
			write_integer_64 as append_integer_64,
			write_natural_8 as append_natural_8,
			write_natural_16 as append_natural_16,
			write_natural_32 as append_natural_32,
			write_natural_64 as append_natural_64,
			write_raw_string_8 as append_raw_string_8,
			write_real_32 as append_real,
			write_real_64 as append_double,
			write_string as append_string,
			write_string_8 as append_string_8,
			write_string_32 as append_string_32,
			write_string_general as append_string_general,
			write_boolean as append_boolean,
			write_pointer as append_pointer
		undefine
			copy, is_equal, out, append_string_general
		end

	STRING_GENERAL
		rename
			append as append_string_general,
			append_code as append_z_code,
			append_substring as append_substring_general,
			code as z_code,
			ends_with as ends_with_general,
			has_code as has_unicode,
			is_case_insensitive_equal as is_case_insensitive_equal_general,
			prepend as prepend_string_general,
			prepend_substring as prepend_substring_general,
			put_code as put_z_code,
			same_caseless_characters as same_caseless_characters_general,
			substring_index as substring_index_general,
			starts_with as starts_with_general
		undefine
			copy, hash_code, out, index_of, last_index_of, occurrences,
--			Status query
			ends_with_general, has, has_unicode,
			is_double, is_equal, is_integer, is_integer_32, is_real_64,
			same_characters, starts_with_general,
--			Conversion
			to_boolean, to_double, to_real_64, to_integer, to_integer_32,
			as_string_32, to_string_32, as_string_8, to_string_8, split,
--			Element change
			append_string_general
		redefine
--			Element change
			append_substring_general, prepend_string_general
		end

	INDEXABLE [CHARACTER_32, INTEGER]
		rename
			upper as count
		undefine
			copy, is_equal, out
		redefine
			changeable_comparison_criterion, prune_all
		end

	RESIZABLE [CHARACTER_32]
		undefine
			copy, is_equal, out
		redefine
			changeable_comparison_criterion
		end

create
	make, make_empty, make_from_string, make_from_general, make_from_utf_8, make_shared,
	make_from_other, make_filled, make_from_latin_1_c, make_from_zcode_area

convert
	make_from_general ({STRING_8, STRING_32, IMMUTABLE_STRING_8, IMMUTABLE_STRING_32}),

	to_string_32: {STRING_32}, to_latin_1: {STRING}

feature -- Access

	plus alias "+" (s: READABLE_STRING_GENERAL): like Current
		do
			Result := new_string (count + s.count)
			Result.append (Current)
			Result.append_string_general (s)
		end

feature -- Basic operations

	do_with_splits (delimiter: READABLE_STRING_GENERAL; action: PROCEDURE [like Current])
		-- apply `action' for all delimited substrings
		local
			split_list: EL_SPLIT_ZSTRING_LIST
		do
			create split_list.make (Current, delimiter)
			split_list.do_all (action)
		end

feature -- Status query

	Changeable_comparison_criterion: BOOLEAN = False

	for_all_split (delimiter: READABLE_STRING_GENERAL; predicate: PREDICATE [like Current]): BOOLEAN
		-- `True' if all split substrings match `predicate'
		local
			split_list: EL_SPLIT_ZSTRING_LIST
		do
			create split_list.make (Current, delimiter)
			Result := split_list.for_all (predicate)
		end

	there_exists_split (delimiter: READABLE_STRING_GENERAL; predicate: PREDICATE [like Current]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		local
			split_list: EL_SPLIT_ZSTRING_LIST
		do
			create split_list.make (Current, delimiter)
			Result := split_list.there_exists (predicate)
		end

feature -- Element change

	append_all (a_list: ITERABLE [like Current])
		local
			cursor: ITERATION_CURSOR [like Current]
		do
			cursor := a_list.new_cursor
			grow (count + sum_count (cursor))
			if attached {INDEXABLE_ITERATION_CURSOR [like Current]} cursor as l_cursor then
				l_cursor.start
			else
				cursor := a_list.new_cursor
			end
			from until cursor.after loop
				append (cursor.item)
				cursor.forth
			end
		end

	append_all_general (a_list: ITERABLE [READABLE_STRING_GENERAL])
		local
			cursor: ITERATION_CURSOR [READABLE_STRING_GENERAL]
		do
			cursor := a_list.new_cursor
			grow (count + sum_count (cursor))
			if attached {INDEXABLE_ITERATION_CURSOR [READABLE_STRING_GENERAL]} cursor as l_cursor then
				l_cursor.start
			else
				cursor := a_list.new_cursor
			end
			from until cursor.after loop
				append_string_general (cursor.item)
				cursor.forth
			end
		end

	append_character_8 (uc: CHARACTER_8)
		do
			append_unicode (uc.natural_32_code)
		end

	append_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		do
			append_substring (adapted_argument (s, 1), start_index, end_index)
		end

	edit (left_delimiter, right_delimiter: READABLE_STRING_GENERAL; a_edit: PROCEDURE [INTEGER, INTEGER, ZSTRING])
		local
			editor: EL_ZSTRING_EDITOR
		do
			create editor.make (Current)
			editor.for_each (left_delimiter, right_delimiter, a_edit)
		end

	escape (escaper: EL_ZSTRING_ESCAPER)
		do
			make_from_other (escaper.escaped (Current, False))
		end

	insert_character (uc: CHARACTER_32; i: INTEGER)
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			internal_insert_character (c, i)
			shift_unencoded_from (i, 1)
			if c = Unencoded_character then
				put_unencoded_code (uc.natural_32_code, i)
			end
		ensure
			one_more_character: count = old count + 1
			inserted: item (i) = uc
			stable_before_i: elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: elks_checking implies substring (i + 1, count) ~ (old substring (i, count))
		end

	insert_string (s: EL_READABLE_ZSTRING; i: INTEGER)
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		do
			internal_insert_string (s, i)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					shift_unencoded_from (i, s.count)
					insert_unencoded (s.shifted_unencoded (i - 1))

				when Only_current then
					shift_unencoded_from (i, s.count)

				when Only_other then
					set_unencoded_area (s.shifted_unencoded (i - 1).area)
			else
			end
		ensure
			valid_unencoded: is_valid
			inserted: elks_checking implies (Current ~ (old substring (1, i - 1) + old (s.twin) + old substring (i, count)))
		end

	insert_string_general (s: READABLE_STRING_GENERAL; i: INTEGER)
		do
			insert_string (adapted_argument (s, 1), i)
		end

	left_pad (uc: CHARACTER_32; a_count: INTEGER)
		do
			prepend_string (once_padding (uc, a_count))
		end

	prepend, prepend_string (s: EL_READABLE_ZSTRING)
		local
			new_unencoded, old_unencoded: like shifted_unencoded
		do
			internal_prepend (s)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					old_unencoded := shifted_unencoded (s.count)
					create new_unencoded.make_from_other (s)
					new_unencoded.append (old_unencoded)
					unencoded_area := new_unencoded.area
				when Only_current then
					shift_unencoded (s.count)
				when Only_other then
					unencoded_area := s.unencoded_area.twin
			else
			end
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies same_string (old (s + Current))
		end

	prepend_string_general (str: READABLE_STRING_GENERAL)
		do
			prepend_string (adapted_argument (str, 1))
		ensure then
			unencoded_valid: is_valid
		end

	right_pad (uc: CHARACTER_32; a_count: INTEGER)
		do
			append_string (once_padding (uc, a_count))
		end

	set_from_latin_1_c (latin_1_ptr: POINTER)
		local
			latin: EL_STRING_8
		do
			latin := Latin_1_string
			latin.set_from_c (latin_1_ptr)
			if latin.is_ascii then
				set_from_ascii (latin)
			else
				wipe_out
				append_string_general (latin)
			end
		end

	substitute_tuple (inserts: TUPLE)
		do
			make_from_other (substituted_tuple (inserts))
		end

	translate_and_delete (old_characters, new_characters: EL_READABLE_ZSTRING)
		do
			translate_deleting_null_characters (old_characters, new_characters, True)
		end

feature -- Removal

	prune (uc: CHARACTER_32)
		local
			i: INTEGER
		do
			i := index_of (uc, 1)
			if i > 0 then
				remove (i)
			end
		end

	prune_all (uc: CHARACTER_32)
		local
			i, j, l_count: INTEGER; c, c_i: CHARACTER; l_unicode, unicode_i: NATURAL; l_area: like area
			l_new_unencoded: like empty_once_unencoded; unencoded: like unencoded_indexable
		do
			c := encoded_character (uc); l_unicode := uc.natural_32_code
			if has_mixed_encoding then
				l_area := area; l_count := count
				l_new_unencoded := empty_once_unencoded; unencoded := unencoded_indexable
				from  until i = l_count loop
					c_i := l_area.item (i)
					if c_i = Unencoded_character then
						unicode_i := unencoded.code (i + 1)
						if l_unicode /= unicode_i then
							l_area.put (c_i, j)
							l_new_unencoded.put_unicode (unicode_i, j + 1)
							j := j + 1
						end
					elseif c_i /= c then
						l_area.put (c_i, j)
						j := j + 1
					end
					i := i + 1
				end
				count := j
				l_area [j] := '%U'
				set_from_list (l_new_unencoded)
				reset_hash
			elseif c /= Unencoded_character then
				internal_prune_all (c)
			end
		ensure then
			valid_unencoded: is_valid
			changed_count: count = (old count) - (old occurrences (uc))
		end

	prune_all_leading (uc: CHARACTER_32)
			-- Remove all leading occurrences of `c'.
		do
			remove_head (leading_occurrences (uc))
		end

	prune_all_trailing (uc: CHARACTER_32)
			-- Remove all trailing occurrences of `c'.
		do
			remove_tail (trailing_occurrences (uc))
		end

	remove (i: INTEGER)
		do
			internal_remove (i)
			remove_unencoded_substring (i, i)
		ensure then
			valid_unencoded: is_valid
		end

	remove_quotes
		require
			long_enough: count >= 2
		do
			remove_head (1); remove_tail (1)
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			internal_remove_substring (start_index, end_index)
			remove_unencoded_substring (start_index, end_index)
		ensure
			valid_unencoded: is_valid
			removed: elks_checking implies Current ~ (old substring (1, start_index - 1) + old substring (end_index + 1, count))
		end

	wipe_out
		do
			internal_wipe_out
			internal_hash_code := 0
			make_unencoded
		end

feature {NONE} -- Implementation

	append_raw_character_8 (c: CHARACTER)
		do
			append_character (c)
		end

	append_string_8 (str: READABLE_STRING_8)
		do
			append_string_general (str)
		end

	append_string_32 (str: READABLE_STRING_32)
		do
			append_string_general (str)
		end

	append_pointer (ptr: POINTER)
		do
			append_string_general (ptr.out)
		end

	empty_escape_table: like Once_escape_table
		do
			Result := Once_escape_table
			Result.wipe_out
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

	once_padding (uc: CHARACTER_32; a_count: INTEGER): like Current
		local
			i, difference: INTEGER; pad_code: NATURAL
		do
			pad_code := Codec.as_z_code (uc)
			Result := Once_adapted_argument [0]
			Result.wipe_out
			difference := a_count - count
			from i := 1 until i > difference loop
				Result.append_z_code (pad_code)
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Once_escape_table: HASH_TABLE [NATURAL, NATURAL]
		once
			create Result.make (5)
		end

note

	notes: "[
		**DEFAULT CODEC**
		
		By default `area' characters are encoded using the codec {[$source EL_ZCODEC_FACTORY]}.default_codec. By
		default this is ISO-8859-15 but can be set for the application using the command line option:
		
			-system_codec [name]
			
		Example:
		
			-system_codec WINDOWS-1258
		
		**FEATURES**
		
		`ZSTRING' has many useful routines not found in `STRING_32'. Probably the most useful is Python style templates 
		using the `#$' as an alias for `substituted_tuple', and place holders indicated by `%S', which by coincidence is
		both an Eiffel escape sequence and a Python one (Python is actually `%s').
		
		**ARTICLES**
		
		There is a detailed article about this class here: [https://www.eiffel.org/blog/finnianr/introducing_class_zstring]

		**CAVEAT**

		There is a caveat attached to using `ZSTRING' which is that if your application uses very many characters outside of
		the ISO-8859-15 character-set, the execution efficiency does down substantially.
		See [./benchmarks/zstring.html these benchmarks]

		This is something to consider if your application is going to be used in for example: Russia or Japan.
		If the user locale is for a language that is supported by a ISO-8859-x what you can do is over-ride
		`{[$source EL_SHARED_ZSTRING_CODEC]}.Default_codec', and initialize it immediately after application launch.
		This will force `ZSTRING' to switch to a more optimal character-set for the user-locale.

		The execution performance will be worst for Asian characters.

		A planned solution is to make a swappable alternative implementation that works equally well with Asian character sets
		and non-Western European sets. The version used can be set by changing an ECF variable or perhaps the build target.

		There two ways to go about achieving an efficient implementation for Asian character sets:

		1. Change the implementation to inherit from `STRING_32'. This will be the fastest and easiest to implement.
		2. Change the area array to type: `SPECIAL [NATURAL_16]' and then the same basic algorithm can be applied to Asian characters.
		The problem is `NATURAL_16' is not a character and there is no `CHARACTER_16', so it will entail a lot of changes. The upside is
		that there will still be a substantial memory saving.
	]"

end