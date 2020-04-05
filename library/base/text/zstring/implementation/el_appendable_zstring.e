note
	description: "Appendable/Prependable aspects of [$source EL_ZSTRING] that use only 8-bit implemenation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 15:44:57 GMT (Sunday 5th April 2020)"
	revision: "3"

deferred class
	EL_APPENDABLE_ZSTRING

feature {NONE} -- Append integers

	append_integer, append_integer_32 (n: INTEGER)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer (n)
			set_from_string_8 (str)
		end

	append_integer_16 (n: INTEGER_16)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer_16 (n)
			set_from_string_8 (str)
		end

	append_integer_64 (n: INTEGER_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer_64 (n)
			set_from_string_8 (str)
		end

	append_integer_8 (n: INTEGER_8)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_integer_8 (n)
			set_from_string_8 (str)
		end

feature {NONE} -- Append naturals

	append_natural, append_natural_32 (n: NATURAL)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_32 (n)
			set_from_string_8 (str)
		end

	append_natural_16 (n: NATURAL_16)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_16 (n)
			set_from_string_8 (str)
		end

	append_natural_64 (n: NATURAL_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_64 (n)
			set_from_string_8 (str)
		end

	append_natural_8 (n: NATURAL_8)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_natural_8 (n)
			set_from_string_8 (str)
		end

feature {NONE} -- Append general

	append (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Append characters of `s' at end.
		local
			str: like current_string_8
		do
			str := current_string_8
			str.append (string_8_argument (s, 1))
			set_from_string_8 (str)
		ensure
			new_count: count = old count + old s.count
			appended: elks_checking implies string.same_string (old (string + s.string))
		end

	append_boolean (b: BOOLEAN)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_boolean (b)
			set_from_string_8 (str)
		end

	append_substring (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Append characters of `s.substring (start_index, end_index)' at end.
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		local
			str: like current_string_8
		do
			str := current_string_8
			str.append_substring (string_8_argument (s, 1), start_index, end_index)
			set_from_string_8 (str)
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies string.same_string (old (string + s.substring (start_index, end_index)))
		end

	append_tuple_item (tuple: TUPLE; i: INTEGER)
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Boolean_code then
					append_boolean (tuple.boolean_item (i))

				when {TUPLE}.Integer_8_code then
					append_integer_8 (tuple.integer_8_item (i))

				when {TUPLE}.Integer_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					append_integer (tuple.integer_item (i))

				when {TUPLE}.Integer_64_code then
					append_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_8_code then
					append_natural_8 (tuple.natural_8_item (i))

				when {TUPLE}.Natural_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Natural_32_code then
					append_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					append_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Real_32_code then
					append_real (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					append_double (tuple.real_64_item (i))

			else
			end
		end

feature {NONE} -- Append REAL

	append_real_32, append_real (n: REAL_32)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_real (n)
			set_from_string_8 (str)
		end

	append_real_64, append_double (n: REAL_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.append_double (n)
			set_from_string_8 (str)
		end

feature {NONE} -- Prepend general

	prepend (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
			-- Prepend characters of `s' at front.
		require
			argument_not_void: s /= Void
		do
			insert_string (s, 1)
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies string.same_string (old (s.string + string))
		end

	prepend_boolean (b: BOOLEAN)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_boolean (b)
			set_from_string_8 (str)
		end

	prepend_integer, prepend_integer_32 (n: INTEGER)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_integer (n)
			set_from_string_8 (str)
		end

	prepend_real_32, prepend_real (n: REAL_32)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_real (n)
			set_from_string_8 (str)
		end

	prepend_real_64, prepend_double (n: REAL_64)
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_double (n)
			set_from_string_8 (str)
		end

	prepend_character (c: CHARACTER_8)
			-- Add `c' at front.
		local
			str: like current_string_8
		do
			str := current_string_8; str.prepend_character (c)
			set_from_string_8 (str)
		ensure
			new_count: count = old count + 1
		end

	prepend_substring (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; start_index, end_index: INTEGER)
			-- Append characters of `s.substring (start_index, end_index)' at end.
		require
			start_index_valid: start_index >= 1
			end_index_valid: end_index <= s.count
			valid_bounds: start_index <= end_index + 1
		local
			str: like current_string_8
		do
			str := current_string_8
			str.prepend_substring (string_8_argument (s, 1), start_index, end_index)
			set_from_string_8 (str)
		ensure
			new_count: count = old count + end_index - start_index + 1
			prepended: elks_checking implies string.same_string (old (s.substring (start_index, end_index) + string))
		end

feature {NONE} -- Implementation

	count: INTEGER
		deferred
		end

	current_string_8: EL_STRING_8
		deferred
		end

	elks_checking: BOOLEAN
		deferred
		end

	insert_string (s: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; i: INTEGER)
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		deferred
		ensure
			inserted: elks_checking implies (string ~ (old substring (1, i - 1) + old (s.string) + old substring (i, count)))
		end

	set_from_string_8 (str: EL_STRING_8)
		deferred
		end

	string: EL_STRING_8
		deferred
		end

	string_8_argument (zstr: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION; index: INTEGER): EL_STRING_8
		require
			valid_index: 1 <= index and index <= 2
		deferred
		end

	substring (start_index, end_index: INTEGER): like string
		deferred
		end

end
