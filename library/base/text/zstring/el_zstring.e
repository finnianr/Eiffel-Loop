note
	description: "[
		Usually referenced with the alias **ZSTRING**, this string is a memory efficient alternative to using
		${STRING_32}. When an application mainly uses characters from the ISO-8859-15 character set,
		the memory saving can be as much as 70%, while the execution efficiency is roughly the same as for
		${STRING_8}. For short strings the saving is much less: about 50%.
		ISO-8859-15 covers most Western european languages.
	]"
	tests: "Class ${ZSTRING_TEST_SET}"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 12:01:57 GMT (Tuesday 15th April 2025)"
	revision: "128"

class
	EL_ZSTRING

inherit
	EL_READABLE_ZSTRING
		rename
			append_string_8 as append_raw_string_8
		export
			{ANY}
--				Element change
				append_boolean, append_area_32, append_character, append_character_8,

				append_double, append_real, append_integer, append_natural,
				append_real_32, append_real_64, append_rounded_real, append_rounded_double,
				append_integer_8, append_integer_16, append_integer_32, append_integer_64,
				append_natural_8, append_natural_16, append_natural_32, append_natural_64,

				append_replaced, append_raw_string_8, append_from_right, append_from_right_general,
				append_string, append, append_string_general, append_substring, append_substring_general,
				append_utf_8, append_utf_16_le, append_encoded, append_encodeable, append_encoded_any,
				append_unicode,
				extend, enclose, fill_blank, fill_character, multiply,

				prepend_boolean, prepend_character, prepend_integer, prepend_integer_32,
				prepend_real_32, prepend_real, prepend_real_64, prepend_double, prepend_substring,
				prepend, prepend_string, prepend_string_general, prepend_compatible,

				precede, put_unicode, quote, translate,
--				Transformation
				crop, expand_tabs, hide, mirror, replace_character, replace_delimited_substring,
				replace_delimited_substring_general, replace_substring, replace_substring_all, replace_substring_general,
				replace_set_members_8, replace_set_members, reveal,
				to_canonically_spaced, to_lower, to_proper, to_upper, translate_or_delete,
				unescape,
--				Removal
				keep_head, keep_tail, left_adjust, remove_bookends, remove_double, remove_head, remove_ends, remove_tail,
				right_adjust, remove_single, remove_quotes,
				prune_all_leading, prune_all_trailing,
--				Contract support
				Encoding
			{EL_SHARED_ZSTRING_CODEC} order_comparison
			{EL_ZSTRING_BASE} append_string_general_for_type
			{EL_ZCODEC} Once_interval_list
		redefine
			new_list
		select
			String_searcher
		end

	EL_WRITABLE
		rename
			write_encoded_character_8 as append_raw_character_8,
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
			write_encoded_string_8 as append_raw_string_8,
			write_real_32 as append_real,
			write_real_64 as append_double,
			write_string as append_string,
			write_string_8 as append_string_8,
			write_string_32 as append_string_32,
			write_string_general as append_string_general,
			write_boolean as append_boolean,
			write_pointer as append_pointer
		undefine
			append_string_general
		redefine
			write_path, write_path_steps
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
			same_characters as same_characters_general,
			same_string as same_string_general,
			split as split_list,
			starts_with as starts_with_general
		undefine
			copy, hash_code, out, index_of, last_index_of, occurrences,
--			Status query
			ends_with_general, has, has_unicode,
			is_real, is_real_32, is_double, is_equal, is_real_64,
			is_integer_8, is_integer_16, is_integer, is_integer_32, is_integer_64,
			is_natural_8, is_natural_16, is_natural, is_natural_32, is_natural_64,
--			Comparison
			same_characters_general, starts_with_general, same_caseless_characters_general,
--			Conversion
			to_boolean, to_real, to_real_32, to_double, to_real_64,
			to_integer_8, to_integer_16, to_integer, to_integer_32, to_integer_64,
			to_natural_8, to_natural_16, to_natural, to_natural_32, to_natural_64,
			as_string_32, to_string_32, as_string_8, to_string_8, split_list,
--			Element change
			append_string_general, append_substring_general, prepend_string_general,
--			Implementation
			is_valid_integer_or_natural
		end

	INDEXABLE [CHARACTER_32, INTEGER]
		rename
			upper as count
		undefine
			copy, is_equal, out, new_cursor
		redefine
			changeable_comparison_criterion, prune_all
		end

	RESIZABLE [CHARACTER_32]
		undefine
			copy, is_equal, out
		redefine
			changeable_comparison_criterion
		end

	DEBUG_OUTPUT -- not working
		rename
			debug_output as to_string_32
		undefine
			copy, is_equal, out
		end

create
	make, make_empty, make_from_zcode_area, make_shared, make_filled, make_from_file,

-- other strings
	make_from_other, make_from_string, make_from_string_8, make_from_general, make_from_substring,

--	Encodings
	make_from_utf_8, make_from_utf_16_le, make_from_latin_1_c

convert
--	from
	make_from_general ({STRING_8, STRING_32, IMMUTABLE_STRING_8, IMMUTABLE_STRING_32}),
--	to
	to_string_32: {STRING_32}, to_latin_1: {STRING}

feature {NONE} -- Initialization

	make_shared (other: ZSTRING; n: INTEGER)
		require
			valid_new_count: n <= other.count
		do
			share (other)
			set_count (n)
		end

feature -- Duplication

	plus alias "+" (s: READABLE_STRING_GENERAL): like Current
		do
			Result := new_string (count + s.count)
			Result.append (Current)
			Result.append_string_general (s)
		end

feature -- Basic operations

	do_with_splits (a_separator: READABLE_STRING_GENERAL; action: PROCEDURE [like Current])
		-- apply `action' for all delimited substrings
		do
			across split_on_string (a_separator) as str loop
				action (str.item_copy)
			end
		end

feature -- Status query

	Changeable_comparison_criterion: BOOLEAN = False

	for_all_split (a_separator: READABLE_STRING_GENERAL; is_true: PREDICATE [like Current]): BOOLEAN
		-- `True' if all split substrings match `is_true'
		do
			Result := across split_on_string (a_separator) as str all is_true (str.item) end
		end

	there_exists_split (a_separator: READABLE_STRING_GENERAL; is_true: PREDICATE [like Current]): BOOLEAN
		-- `True' if one split substring matches `is_true'
		do
			Result := across split_on_string (a_separator) as str some is_true (str.item) end
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

	edit (left_delimiter, right_delimiter: READABLE_STRING_GENERAL; a_edit: PROCEDURE [INTEGER, INTEGER, ZSTRING])
		local
			editor: EL_ZSTRING_EDITOR
		do
			create editor.make (Current)
			editor.for_each (left_delimiter, right_delimiter, a_edit)
		end

	escape (escaper: EL_STRING_ESCAPER [ZSTRING])
		do
			make_from_other (escaper.escaped (Current, False))
		end

	insert_character (uc: CHARACTER_32; i: INTEGER)
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			String_8.insert_character (Current, c, i)
			shift_unencoded_from (i, 1)
			inspect c
				when Substitute then
					put_unencoded (uc, i)
			else
			end
		ensure
			one_more_character: count = old count + 1
			inserted: item (i) = uc
			stable_before_i: elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: elks_checking implies substring (i + 1, count) ~ (old substring (i, count))
		end

	insert_string (s: EL_READABLE_ZSTRING; i: INTEGER)
		local
			l_count, old_count: INTEGER
		do
			old_count := count
			internal_insert_string (s, i)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					if attached empty_unencoded_buffer as buffer then
						l_count := i - 1
						if l_count.to_boolean then
							buffer.append_substring (Current, 1, i - 1, 0)
						end
						if s.count.to_boolean then
							buffer.append (s, l_count)
							l_count := l_count + s.count
						end
						if i <= old_count then
							buffer.append_substring (Current, i, old_count, l_count)
						end
						set_unencoded_from_buffer (buffer)
					end

				when Only_current then
					shift_unencoded_from (i, s.count)

				when Only_other then
					append_unencoded (s, i - 1)
			else
			end
		end

	insert_string_general (s: READABLE_STRING_GENERAL; i: INTEGER)
		do
			insert_string (adapted_argument (s, 1), i)
		end

	left_pad (uc: CHARACTER_32; a_count: INTEGER)
		do
			prepend_string (new_padding (uc, a_count))
		end

	right_pad (uc: CHARACTER_32; a_count: INTEGER)
		do
			append_string (new_padding (uc, a_count))
		end

	set_from_latin_1_c (latin_1_ptr: POINTER)
		local
			latin: EL_STRING_8
		do
			latin := String_8.c_string (latin_1_ptr)
			if latin.is_ascii then
				set_from_ascii (latin)
			else
				wipe_out
				append_string_general (latin)
			end
		end

	share (other: ZSTRING)
		do
			internal_share (other)
			unencoded_area := other.unencoded_area
		end

	share_8 (latin_1: STRING_8)
		--
		require
			is_shareable_8 (latin_1)
		do
			area := latin_1.area; unencoded_area := Empty_unencoded
			set_count (latin_1.count)
		end

	substitute_tuple (inserts: TUPLE)
		do
			make_from_other (substituted_tuple (inserts))
		end

feature -- Removal

	prune (uc: CHARACTER_32)
		-- Remove one occurrence of `uc' if any. (`INDEXABLE' implementation)
		local
			i: INTEGER
		do
			i := index_of (uc, 1)
			if i > 0 then
				remove (i)
			end
		end

	prune_all (uc: CHARACTER_32)
		-- Remove all occurrences of `c'.  (`INDEXABLE' redefinition)
		local
			i, j, i_upper, block_index, last_upper: INTEGER; encoded_c, c_i: CHARACTER_8; uc_i: CHARACTER_32
			c_is_substitute: BOOLEAN; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			i_upper := count - 1
			encoded_c := encoded_character (uc); c_is_substitute := encoded_c = Substitute
			if attached area as l_area and then attached unencoded_area as uc_area and then uc_area.count > 0
				and then attached empty_unencoded_buffer as buffer
			then
				last_upper := buffer.last_upper
				from until i > i_upper loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							uc_i := iter.item ($block_index, uc_area, i + 1)
							if c_is_substitute implies uc_i /= uc then
								l_area [j] := c_i
								last_upper := buffer.extend (uc_i, last_upper, j + 1)
								j := j + 1
							end

					else
						if encoded_c /= c_i then
							l_area [j] := c_i
							j := j + 1
						end
					end
					i := i + 1
				end
				buffer.set_last_upper (last_upper)
				set_unencoded_from_buffer (buffer)

			elseif attached area as l_area then
				from until i > i_upper loop
					c_i := l_area [i]
					if c_i /= encoded_c then
						l_area [j] := c_i
						j := j + 1
					end
					i := i + 1
				end
			end
			set_count (j)
		end

	remove (i: INTEGER)
		do
			internal_remove (i)
			remove_unencoded_substring (i, i)
		ensure then
			valid_unencoded: is_valid
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			String_8.remove_substring (Current, start_index, end_index)
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

feature {NONE} -- Factory

	new_list (a_count: INTEGER): EL_ZSTRING_LIST
		do
			create Result.make (a_count)
		end

	new_padding (uc: CHARACTER_32; a_count: INTEGER): like Current
		local
			delta: INTEGER
		do
			delta := a_count - count
			if delta > 0 then
				create Result.make_filled (uc, delta)
			else
				Result := Once_adapted_argument [0]
				Result.wipe_out
			end
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

feature {NONE} -- Implementation

	append_pointer (ptr: POINTER)
		do
			append_string_general (ptr.out)
		end

	append_raw_character_8 (c: CHARACTER)
		do
			append_character (c)
		end

	append_string_32 (str: READABLE_STRING_32)
		do
			append_string_general_for_type (str, string_storage_type (str))
		end

	append_string_8 (str: READABLE_STRING_8)
		do
			append_string_general_for_type (str, '1')
		end

	current_zstring: ZSTRING
		do
			Result := Current
		end

	current_writable: EL_WRITABLE
		do
			Result := Current
		end

	empty_escape_table: like Once_escape_table
		do
			Result := Once_escape_table
			Result.wipe_out
		end

	sum_count (cursor: ITERATION_CURSOR [READABLE_STRING_GENERAL]): INTEGER
		do
			from until cursor.after loop
				Result := Result + cursor.item.count
				cursor.forth
			end
		end

	write_path (path: EL_PATH)
		do
			path.append_to (Current)
		end

	write_path_steps (steps: EL_PATH_STEPS)
		do
			steps.append_to (Current)
		end

feature {NONE} -- Constants

	Once_escape_table: EL_HASH_TABLE [NATURAL, NATURAL]
		once
			create Result.make (5)
		end

note
	notes: "[
		**DEFAULT CODEC**
		
		By default `area' characters are encoded using the codec ${EL_SHARED_ZCODEC_FACTORY}.default_codec. By
		default this is ISO-8859-15 but can be set for the application using the command line option:
		
			-zstring_codec [name]
			
		Example:
		
			-zstring_codec WINDOWS-1258
			
		See class constant ${EL_ZCODEC_FACTORY}.Codec_option_name.
	
		**FEATURES**
		
		**ZSTRING** has many useful routines not found in ${STRING_32}. Probably the most useful is Python style templates 
		using the `#$' as an alias for `substituted_tuple', and place holders indicated by `%S', which by coincidence is
		both an Eiffel escape sequence and a Python one (Python is actually `%s').
		
		**ARTICLES**
		
		There is a detailed article about this class here: [https://www.eiffel.org/blog/finnianr/introducing_class_zstring]

		**BENCHMARKS**

		Comparison of **ZSTRING** against ${STRING_32} for basic string operations

		* [./benchmark/ZSTRING-benchmarks-latin-1.html Latin-1 base encoding]
		* [./benchmark/ZSTRING-benchmarks-latin-15.html Latin-15 base encoding]

		**CAVEAT**

		There is a caveat attached to using **ZSTRING** which is that if your application uses very many characters outside of
		the ISO-8859-15 character-set, the execution efficiency does down substantially.

		This is something to consider if your application is going to be used in for example: Russia or Japan.
		If the user locale is for a language that is supported by a ISO-8859-x what you can do is over-ride
		${EL_SHARED_ZSTRING_CODEC}.Default_codec and initialize it immediately after application launch. 
		This will force **ZSTRING** to switch to a more optimal character-set for the user-locale.
		
		The execution performance will be slow for Asian characters, but a planned solution is to make a swappable alternative
		implementation that works equally well with Asian character sets and non-Western European sets.
		The version used can be set by changing an ECF variable or perhaps the build target.

		There two ways to go about achieving an efficient implementation for Asian character sets:

		1. Change the implementation to inherit from ${STRING_32}. This will be the fastest and easiest to implement.
		2. Change the area array to type: ${SPECIAL [NATURAL_16]} and then the same basic algorithm can be applied to Asian characters.
		The problem is ${NATURAL_16} is not a character and there is no **CHARACTER_16**, so it will entail a lot of changes.
		The upside is that there will still be a substantial memory saving.
		
		**THE CODE FUNCTION**
		
		There is an important difference between how ${ZSTRING} implements the function
		${READABLE_STRING_GENERAL}.code and how ${STRING_32} implements it. For the most
		part ${ZSTRING} will return unicode, but a small subset of characters will be different.
		This is why **code** has been rename as **z_code**. To get true unicode use the function
		${ZSTRING}.unicode
		
		The exception to this rule is if ${ZSTRING}.default_codec has been changed to return an instance of
		${EL_ISO_8859_1_ZCODEC} instead of the default {EL_ISO_8859_15_ZCODEC}. This can be done using the command
		line option `-zstring_codec'.
	]"

end