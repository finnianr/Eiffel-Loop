note
	description: "[
		Capabilities of ${STRING_32} extended with routines from ${EL_EXTENDED_READABLE_STRING_I} and
		${EL_EXTENDED_STRING_GENERAL}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 15:28:44 GMT (Wednesday 16th April 2025)"
	revision: "26"

class
	EL_STRING_32

inherit
	STRING_32
		rename
			replace_character as replace_every_character,
			set_count as set_string_count,
			split as split_list
		export
			{EL_STRING_32_CONSTANTS} String_searcher
			{EL_TYPE_CONVERSION_HANDLER} Ctoi_convertor, Ctor_convertor
		undefine
			same_string
		redefine
			append_string_general, make, resize, share, trim
		end

	EL_EXTENDED_STRING_32
		rename
			empty_target as empty_string_32,
			set_target as share
		undefine
			count, has, is_valid_as_string_8, valid_index
		end

create
	make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			shared_string := Current
		end

feature -- Element change

	set_from_encoded (a_codec: EL_ZCODEC; encoded: READABLE_STRING_8)
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
			a_codec.decode (encoded.count, l_area, area, 0)
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

feature -- Duplication

	enclosed (left, right: CHARACTER_32): STRING_32
		-- copy of target with `left' and `right' character prepended and appended
		do
			create Result.make (count + 2)
			Result.append_character (left)
			Result.append_string (shared_string)
			Result.append_character (right)
		end

	filled (uc: CHARACTER_32; n: INTEGER): STRING_32
		-- shared string filled with `n' number of `c' characters repeated
		do
			Result := Character_string_32_table.item (uc, n)
		end

	pruned (c: CHARACTER_32): STRING_32
		do
			create Result.make_from_string (Current)
			Result.prune_all (c)
		end

	shared_leading (end_index: INTEGER): STRING_32
		-- leading substring of `shared_string' from 1 to `end_index'
		do
			create Result.make_empty
			Result.share (shared_string)
			Result.set_count (end_index)
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
			if conforms_to_zstring (str) and then attached {ZSTRING} str as z_str then
				z_str.append_to_string_32 (Current)
			else
				Precursor (str)
			end
		end

feature {NONE} -- Implementation

	copy_area_32_data (a_area: like area; source: SPECIAL [CHARACTER_32])
		do
			a_area.copy_data (source, 0, count, source.count)
		end

	new_readable: EL_STRING_32
		do
			create Result.make_empty
		end

	new_substring (start_index, end_index: INTEGER): STRING_32
		do
			create Result.make_empty
			Result.share (substring (start_index, end_index))
		end

	other_area (other: READABLE_STRING_32): like area
		do
			Result := other.area
		end

	other_index_lower (other: READABLE_STRING_32): INTEGER
		do
			Result := other.area_lower
		end

	resize (newsize: INTEGER)
		-- Rearrange string so that it can accommodate at least `newsize' characters.
		do
			Precursor (newsize)
			if shared_string /= Current then
				shared_string.share (Current)
			end
		end

	set_count (n: INTEGER)
		do
			set_string_count (n)
			if shared_string /= Current then
				shared_string.set_count (n)
			end
		end

	split_on_character (separator: CHARACTER_32): like Split_string_32
		do
			Result := Split_string_32
			Result.set_target (Current); Result.set_separator (separator)
		end

	trim
		 -- reallocate to new size
		do
			if attached area as l_area then
				Precursor
				if l_area /= area and then shared_string /= Current then
					shared_string.share (Current)
				end
			end
		end

feature {NONE} -- Internal attributes

	shared_string: STRING_32

feature {NONE} -- Constants

	Split_string_32: EL_SPLIT_ON_CHARACTER_32 [STRING_32]
		once
			create Result.make (Empty_string_32, '_')
		end

end