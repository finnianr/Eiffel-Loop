note
	description: "[$source CHARACTER_32] iterator for [$source EL_READABLE_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 13:25:38 GMT (Sunday 12th November 2023)"
	revision: "16"

class
	EL_ZSTRING_ITERATION_CURSOR

inherit
	STRING_32_ITERATION_CURSOR
		rename
			area as unencoded_area
		redefine
			item, make, target
		end

	EL_STRING_ITERATION_CURSOR
		rename
			Unicode_table as Shared_unicode_table,
			set_target as make
		export
			{NONE} fill_z_codes
		redefine
			utf_8_byte_count
		end

	EL_32_BIT_IMPLEMENTATION

	EL_ZSTRING_CONSTANTS
		rename
			empty_string as empty_target
		end

	DISPOSABLE
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make, make_empty

feature {EL_SHARED_ZSTRING_CURSOR} -- Initialization

	make (a_target: EL_READABLE_ZSTRING)
		do
			Precursor (a_target)
			if block_index_ptr = default_pointer then
				block_index_ptr := block_index_ptr.memory_calloc (1, {PLATFORM}.Integer_32_bytes)
			else
				block_index_ptr.memory_set (0, {PLATFORM}.Integer_32_bytes)
			end
			area := a_target.area
			unicode_table := Shared_unicode_table
		end

feature -- Access

	item: CHARACTER_32
		local
			code: INTEGER; i: INTEGER; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			i := target_index
			code := area [i - 1].code
			if code = Substitute_code then
				Result := iter.item (block_index_ptr, unencoded_area, i)
			elseif code <= Max_7_bit_code then
				Result := code.to_character_32
			else
				Result := Unicode_table [code]
			end
		end

	z_code: NATURAL
		local
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			Result := iter.i_th_z_code (block_index_ptr, area, unencoded_area, target_index)
		end

feature -- Measurement

	latin_1_count: INTEGER
		local
			i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i loop
				if l_area.item (i).natural_32_code <= 0xFF then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		do
			Result := target.leading_occurrences (uc)
		end

	leading_white_count: INTEGER
		do
			Result := target.leading_white_space
		end

	target_count: INTEGER
		do
			Result := target.count
		end

	trailing_white_count: INTEGER
		do
			Result := target.trailing_white_space
		end

	utf_8_byte_count: INTEGER
		do
			Result := target.utf_8_byte_count
		end

feature -- Status query

	all_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		local
			c_8: EL_CHARACTER_8_ROUTINES
		do
			if not target.has_mixed_encoding then
				Result := c_8.is_ascii_area (area, area_first_index, area_last_index)
			end
		end

	has_character_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurrs between `start_index' and `end_index'
		do
			Result := target.has_between (uc, start_index, end_index)
		end

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		local
			i, i_final, block_index: INTEGER; c_i: CHARACTER; uc: CHARACTER_32
			iter: EL_UNENCODED_CHARACTER_ITERATION; unicode: like codec.unicode_table
		do
			codec.decode (n, area, destination, 0)
			unicode := codec.unicode_table
			if attached area as l_area and then attached unencoded_area as area_32 then
				i_final := source_index + area_first_index + n
				from i := source_index + area_first_index until i = i_final loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc := iter.item ($block_index, area_32, i - area_first_index + 1)
					else
						uc := unicode [c_i.code]
					end
					destination.extend (uc)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	dispose
			-- Release memory pointed by `item'.
		do
			block_index_ptr.memory_free
		end

	is_i_th_eiffel_identifier (a_area: like area; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		local
			c8: EL_CHARACTER_8_ROUTINES
		do
			Result := c8.is_i_th_eiffel_identifier (a_area, i, case_code, first_i)
		end

	i_th_ascii_character (a_area: like area; i: INTEGER): CHARACTER_8
		local
			c: CHARACTER_8
		do
			c := a_area [i]
			if c.natural_32_code <= 127 then
				Result := c
			end
		end

	i_th_character_8 (a_area: like area; i: INTEGER): CHARACTER_8
		do
			Result := i_th_character_32 (a_area, i).to_character_8
		end

	i_th_character_32 (a_area: like area; i: INTEGER): CHARACTER_32
		local
			c_i: CHARACTER; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			c_i := a_area [i]
			if c_i = Substitute then
				Result := iter.item (block_index_ptr, unencoded_area, i - area_first_index + 1)
			else
				Result := unicode_table [c_i.code]
			end
		end

	i_th_unicode (a_area: like area; i: INTEGER): NATURAL
		do
			Result := i_th_character_32 (a_area, i).natural_32_code
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Internal attriutes

	area: SPECIAL [CHARACTER]

	block_index_ptr: POINTER
		-- location of unencoded substring

	target: EL_READABLE_ZSTRING

	unicode_table: like codec.unicode_table

end