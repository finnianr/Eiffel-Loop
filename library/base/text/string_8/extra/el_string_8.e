note
	description: "[
		Capabilities of ${STRING_8} extended with routines from ${EL_EXTENDED_READABLE_STRING_I} and
		${EL_EXTENDED_STRING_GENERAL}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 9:13:31 GMT (Saturday 19th April 2025)"
	revision: "43"

class
	EL_STRING_8

inherit
	STRING_8
		rename
			replace_character as replace_every_character,
			split as split_list
		export
			{EL_STRING_8_CONSTANTS} String_searcher
			{EL_TYPE_CONVERSION_HANDLER}
				Ctoi_convertor, Ctor_convertor, is_valid_integer_or_natural
		undefine
			same_string
		redefine
			append_string_general, make, trim, share
		end

	EL_EXTENDED_STRING_8
		rename
			set_target as share
		undefine
			count, has, is_valid_as_string_8, occurrences, valid_index
		end

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make_from_zstring, make_empty, make, make_from_string

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			shared_string := Current
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

feature -- Comparison

	same_strings (a, b: READABLE_STRING_8): BOOLEAN
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		do
			if a.count = b.count then
				Result := same_area_items (a.area, b.area, a.area_lower, b.area_lower, a.count)
			end
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

	append_string_general (str: READABLE_STRING_GENERAL)
		do
			if conforms_to_zstring (str) and then attached {ZSTRING} str as z_str then
				z_str.append_to_string_8 (Current)
			else
				Precursor (str)
			end
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

feature -- Duplication

	enclosed (left, right: CHARACTER_8): STRING_8
		-- copy of target with `left' and `right' character prepended and appended
		do
			create Result.make (count + 2)
			Result.append_character (left)
			Result.append_string (shared_string)
			Result.append_character (right)
		end

	filled (c: CHARACTER_8; n: INTEGER): STRING_8
		-- shared string filled with `n' number of `c' characters repeated
		do
			Result := Character_string_8_table.item (c, n)
		end

	pruned (c: CHARACTER_8): STRING_8
		do
			create Result.make_from_string (Current)
			Result.prune_all (c)
		end

	shared_leading (end_index: INTEGER): STRING_8
		-- leading substring of `shared_string' from 1 to `end_index'
		do
			create Result.make_empty
			Result.share (shared_string)
			Result.set_count (end_index)
		end

feature {NONE} -- Implementation

	copy_area_32_data (a_area: like area; source: SPECIAL [CHARACTER_32])
		local
			i, i_upper, offset: INTEGER; uc: CHARACTER_32
		do
			i_upper := source.count - 1; offset := count
			from i := 0 until i > i_upper loop
				uc := source [i]
				if uc.is_character_8 then
					a_area [i + offset] := uc.to_character_8
				else
					a_area [i + offset] := '%/26/'
				end
				i := i + 1
			end
		end

	new_readable: EL_STRING_8
		do
			create Result.make_empty
		end

	new_substring (start_index, end_index: INTEGER): STRING_8
		do
			create Result.make_empty
			Result.share (substring (start_index, end_index))
		end

	other_area (other: READABLE_STRING_8): like area
		do
			Result := other.area
		end

	other_index_lower (other: READABLE_STRING_8): INTEGER
		do
			Result := other.area_lower
		end

	trim
		-- Fix for BOUNDED invariant when calling `update_shared'
		--		valid_count: count <= capacity
		do
			shared_string.set_count (count)
			Precursor
		end

	update_shared
		 -- update `shared_string'
		do
			if shared_string /= Current then
				shared_string.share (Current)
			end
		end

feature {NONE} -- Internal attributes

	shared_string: STRING_8

end