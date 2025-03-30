note
	description: "Extensions for ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 18:21:47 GMT (Sunday 30th March 2025)"
	revision: "29"

class
	EL_STRING_8

inherit
	STRING_8
		export
			{EL_STRING_8_CONSTANTS} String_searcher
			{EL_TYPE_CONVERSION_HANDLER}
				Ctoi_convertor, Ctor_convertor, is_valid_integer_or_natural
		redefine
			make, share
		end

	EL_STRING_BIT_COUNTABLE [STRING_8]

	EL_SHARED_STRING_8_CURSOR

	EL_SHARED_STRING_8_BUFFER_POOL

	EL_EXTENDED_STRING_GENERAL [CHARACTER_8]

	EL_STRING_8_CONSTANTS

create
	make_from_zstring, make_empty, make, make_from_string

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			shared_string := Empty_string_8
		end

	make_from_zstring (zstr: EL_ZSTRING_CHARACTER_8_BASE)
		do
			set_area_and_count (zstr.area, zstr.count)
		end

feature -- Staus query

	has_padding: BOOLEAN
		-- `True' if `leading_white_count > 0' or `trailing_white_count > 0'
		do
			if count > 0 and then attached area as l_area then
				Result := l_area [0].is_space or else l_area [count - 1].is_space
			end
		end

	is_ascii: BOOLEAN
		-- `True' if all characters in `Current' are in the ASCII character range
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_ascii_area (area, area_lower, area_upper)
		end

feature -- Comparison

	same_strings (a, b: READABLE_STRING_8): BOOLEAN
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		do
			if a.count = b.count then
				Result := same_area_items (a.area, b.area, a.area_lower, b.area_lower, a.count)
			end
		end

feature -- Measurement

	leading_white_count: INTEGER
		do
			Result := cursor_8 (Current).leading_white_count
		end

	trailing_white_count: INTEGER
		do
			Result := cursor_8 (Current).trailing_white_count
		end

feature -- Basic operations

	append_adjusted_to (str: STRING)
		local
			n, i, start_index, end_index, offset: INTEGER
			l_area, o_area: like area
		do
			end_index := count - trailing_white_count
			if end_index.to_boolean then
				start_index := leading_white_count + 1
			else
				start_index := 1
			end
			n := end_index - start_index + 1
			offset := str.count
			str.grow (offset + n)
			str.set_count (offset + n)
			l_area := area; o_area := str.area
			from i := 0 until i = n loop
				o_area [i + offset] := l_area [i + start_index - 1]
				i := i + 1
			end
		end

feature -- Element change

	append_count_from_c (c_string: POINTER; a_count: INTEGER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer_and_count (c_string, a_count)
			grow (count + a_count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, count, a_count)
			count := count + a_count
			internal_hash_code := 0
		end

	append_from_c (c_string: POINTER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer (c_string)
			grow (count + c.count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, count, c.count)
			count := count + c.count
			internal_hash_code := 0
		end

	set_area_and_count (a_area: like area; a_count: INTEGER)
		do
			area := a_area; count := a_count
			internal_hash_code := 0
		end

	set_from_c (c_string: POINTER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer (c_string)
			grow (c.count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, 0, c.count)
			count := c.count
			internal_hash_code := 0
		end

	set_from_c_with_count (c_string: POINTER; a_count: INTEGER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer_and_count (c_string, a_count)
			grow (a_count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, 0, a_count)
			count := a_count
			internal_hash_code := 0
		end

	share (other: STRING_8)
			-- Make current string share the text of `other'.
			-- Subsequent changes to the characters of current string
			-- will also affect `other', and conversely.
		do
			Precursor (other)
			shared_string := other
		end

	unescape (unescaper: EL_STRING_8_UNESCAPER)
		local
			uc: CHARACTER_32
		do
			uc := unescaper.escape_code.to_character_32
			if uc.is_character_8 and then has (uc.to_character_8) then
				if attached String_8_pool.borrowed_item as borrowed then
					if attached borrowed.empty as str then
						unescaper.unescape_into (Current, str)
						wipe_out
						append (str)
					end
					borrowed.return
				end
			end
		end

feature {NONE} -- Implementation

	to_char (uc: CHARACTER_32): CHARACTER_8
		do
			Result := uc.to_character_8
		end

	is_i_th (a_area: like area; i: INTEGER; c: CHARACTER_8): BOOLEAN
		-- `True' if i'th character is equal to `c'
		do
			Result := a_area [i] = c
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		do
			Result := a_area [i].is_alpha
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		do
			Result := a_area [i].is_alpha_numeric
		end

	new_substring (start_index, end_index: INTEGER): STRING_8
		do
			create Result.make_empty
			Result.share (substring (start_index, end_index))
		end

	same_area_items (a, b: like area; a_offset, b_offset, n: INTEGER): BOOLEAN
			-- Are the `n' characters of `b' from `b_offset' position the same as
			-- the `n' characters of `a' from `a_offset'?
		require
			other_not_void: b /= Void
			source_index_non_negative: b_offset >= 0
			destination_index_non_negative: a_offset >= 0
			n_non_negative: n >= 0
			n_is_small_enough_for_source: b_offset + n <= b.count
			n_is_small_enough_for_destination: a_offset + n <= a.count
		local
			i, j, nb: INTEGER
		do
			if a = b and a_offset = b_offset then
				Result := True
			else
				Result := True
				from
					i := b_offset
					j := a_offset
					nb := b_offset + n
				until
					i = nb
				loop
					if b [i] /= a [j] then
						Result := False
						i := nb - 1
					end
					i := i + 1
					j := j + 1
				end
			end
		ensure
			valid_on_empty_area: (n = 0) implies Result
		end

	split_on_character (separator: CHARACTER_8): like Split_string_8
		do
			Result := Split_string_8
			Result.set_target (Current); Result.set_separator (separator)
		end

	update_shared
		do
			shared_string.share (Current)
		end

feature {NONE} -- Internal attributes

	shared_string: STRING_8

feature {NONE} -- Type definitions

	READABLE: READABLE_STRING_8
		once
			create {STRING_8} Result.make_empty
		end

feature {NONE} -- Constants

	Split_string_8: EL_SPLIT_ON_CHARACTER_8 [STRING_8]
		once
			create Result.make (Empty_string_8, '_')
		end

end