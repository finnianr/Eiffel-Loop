note
	description: "Extended ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-01 8:23:00 GMT (Tuesday 1st April 2025)"
	revision: "16"

class
	EL_STRING_32

inherit
	STRING_32
		rename
			replace_character as replace_every_character
		export
			{EL_STRING_32_CONSTANTS} String_searcher
			{EL_TYPE_CONVERSION_HANDLER} Ctoi_convertor, Ctor_convertor
		redefine
			append_string_general, make, share, trim
		end

	EL_STRING_BIT_COUNTABLE [STRING_32]

	EL_EXTENDED_STRING_GENERAL [CHARACTER_32]
		rename
			READABLE_X as READABLE_32
		end

	EL_STRING_32_CONSTANTS

create
	make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			shared_string := Current
		end

feature -- Element change

	set_from_encoded (codec: EL_ZCODEC; encoded: READABLE_STRING_8)
		local
			l_area: SPECIAL [CHARACTER_8]; l_lower: INTEGER
		do
			l_lower := encoded.area_lower
			if l_lower > 0 then
				create l_area.make_empty (encoded.count)
				l_area.copy_data (encoded.area, l_lower, 0, encoded.count)
			else
				l_area := encoded.area
			end
			grow (encoded.count)
			set_count (encoded.count)
			codec.decode (encoded.count, l_area, area, 0)
		end

	set_from_string (zstr: EL_READABLE_ZSTRING)
		do
			wipe_out
			zstr.append_to_string_32 (Current)
		end

	set_from_utf_8 (utf_8_string: READABLE_STRING_8)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			wipe_out
			utf_8.string_8_into_string_general (utf_8_string, Current)
		end

	share (other: STRING_32)
			-- Make current string share the text of `other'.
			-- Subsequent changes to the characters of current string
			-- will also affect `other', and conversely.
		do
			Precursor (other)
			shared_string := other
		end

feature -- Comparison

	same_strings (a, b: READABLE_STRING_32): BOOLEAN
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_32}.same_string'
		do
			if a.count = b.count then
				Result := same_area_items (a.area, b.area, a.area_lower, b.area_lower, a.count)
			end
		end

feature -- Element change

	append_string_general (str: READABLE_STRING_GENERAL)
		do
			if is_zstring (str) and then attached {ZSTRING} str as z_str then
				z_str.append_to_string_32 (Current)
			else
				Precursor (str)
			end
		end

feature {NONE} -- Implementation

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

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		do
			Result := unicode.is_space (a_area [i])
		end

	new_substring (start_index, end_index: INTEGER): STRING_32
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

	split_on_character (separator: CHARACTER_32): like Split_string_32
		do
			Result := Split_string_32
			Result.set_target (Current); Result.set_separator (separator)
		end

	to_char (uc: CHARACTER_32): CHARACTER_32
		do
			Result := uc
		end

	to_character_32 (uc: CHARACTER_32): CHARACTER_32
		do
			Result := uc
		end

	trim
		 -- reallocate to new size
		do
			if shared_string = Current then
				Precursor
			else
				shared_string.trim
			end
		end

	update_shared
		do
			if shared_string /= Current then
				shared_string.share (Current)
			end
		end

feature {NONE} -- Internal attributes

	shared_string: STRING_32

feature {NONE} -- Type definitions

	READABLE_32: READABLE_STRING_32
		once
			Result := Empty_string_32
		end

feature {NONE} -- Constants

	Split_string_32: EL_SPLIT_ON_CHARACTER_32 [STRING_32]
		once
			create Result.make (Empty_string_32, '_')
		end

end