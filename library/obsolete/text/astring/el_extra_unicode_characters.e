note
	description: "[
		A lookup table for unicode characters foreign to character set defined by {EL_ASTRING}.codec
		The index of each character maps to the Ctrl characters from 1:31 excluding 9:13 (Tab to Carriage Return)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-02-24 11:42:38 GMT (Tuesday 24th February 2015)"
	revision: "6"

class
	EL_EXTRA_UNICODE_CHARACTERS

inherit
	STRING_HANDLER

create
	make_empty, make, make_from_other

feature {NONE} -- Initialization

	make_empty
			-- Create empty string.
		do
			area := Default_area
		end

	make (n: INTEGER)
		do
			create area.make_empty (n)
		ensure
			empty: count = 0
			area_allocated: capacity = n
		end

	make_from_other (other: EL_EXTRA_UNICODE_CHARACTERS)
		do
			if other.has_characters then
				area := other.area.twin
			else
				make_empty
			end
		end

feature -- Access

	upper_place_holder: CHARACTER
		local
			l_count: INTEGER
		do
			l_count := count.min (Maximum_place_holder_count)
			if l_count > 8 then
				l_count := l_count + 5
			end
			Result := l_count.to_character_8
		end

	place_holder (c: CHARACTER_32): CHARACTER
			-- place holder code if c found, otherwise '%U'.
		local
			l_index: INTEGER
		do
			l_index := index_of (c)
			if l_index > 8 then
				l_index := l_index + 5
			end
			Result := l_index.min (Maximum_place_holder).to_character_8
		end

	original_character (a_place_holder: CHARACTER): CHARACTER_32
		local
			i: INTEGER
		do
			i := a_place_holder.code
			if a_place_holder > '%/8/' then
				i := i - 5
			end
			Result := area [i - 1]
		end

	original_unicode (a_place_holder: CHARACTER): NATURAL
		local
			i: INTEGER
		do
			i := a_place_holder.code
			if a_place_holder > '%/8/' then
				i := i - 5
			end
			Result := area.item (i - 1).natural_32_code
		end

	index_of (uc: CHARACTER_32): INTEGER
			-- Position of first occurrence of 'uc' at or after 'start_index';
			-- 0 if none.
		local
			l_area: like area
			i, l_count: INTEGER
		do
			l_count := count; l_area := area
			from i := 0 until i = l_count or else l_area.item (i) = uc loop
				i := i + 1
			end
			if i < l_count then
				Result := i + 1
			end
		end

	item (index: INTEGER): CHARACTER_32
		require
			valid_index: index >= 1 and index <= count
		do
			Result := area.item (index - 1)
		end

feature -- Status report

	is_empty: BOOLEAN
		do
			Result := area.count = 0
		end

	is_place_holder_item (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '%/1/'..'%/8/', '%/14/'..'%/31/' then
					Result := c <= upper_place_holder
			else end
--			if c <= '%/31/' and then not ('%T' <= c and c <= '%R') then
--				Result := '%U' < c and c <= upper_place_holder
--			end
		end

	is_space_character (c: CHARACTER): BOOLEAN
		do
			if is_place_holder_item (c) then
				Result := original_character (c).is_space
			else
				Result := c.is_space
			end
		end

	has_characters: BOOLEAN
			-- True if string has extra characters which could not be converted from unicode initialization sring
		do
			Result := area.count > 0
		end

	has (uc: CHARACTER_32): BOOLEAN
		do
			Result := index_of (uc) > 0
		end

	is_over_extended: BOOLEAN
		do
			Result := area.count > Maximum_place_holder_count
		end

feature -- Measurement

	capacity: INTEGER
			-- Allocated space
		do
			Result := area.capacity
		end

	count: INTEGER
		do
			Result := area.count
		end

feature -- Element change

	set_from_area (a_area: like area)
		do
			if a_area.count = 0 then
				area := Default_area
			else
				area := a_area
			end
		end

	extend (c: CHARACTER_32)
			-- Append `c' at end.
		require
			is_new_character: not has (c)
		do
			if count = 0 then
				make (1)
			else
				if count = capacity then
					area := area.resized_area (capacity * 2)
				end
			end
			area.extend (c)
		ensure
			extended: area [count - 1] = c
			one_greater: count = old count + 1
		end

	keep_head (n: INTEGER)
		do
			area.keep_head (n)
			if area.count = 0 then
				area := Default_area
			end
		end

	check_if_over_extended
			-- Set upper place holder to be 'unknown encoding' replacement character if
			-- count > Maximum_place_holder_count
		do
			if count > Maximum_place_holder_count then
				area [Maximum_place_holder_count - 1] := Replacement_character.to_character_32
			end
		ensure
			over_extended_implies_last_place_holder_is_replacement:
				count > Maximum_place_holder_count implies original_character (upper_place_holder) = Replacement_character
		end

feature -- Conversion

	to_upper
			-- Convert to upper case.
		local
			i, l_count: INTEGER
			l_area: like area
		do
			l_count := count; l_area := area
			from i := 0 until i = l_count loop
				l_area.put (l_area.item (i).upper, i)
				i := i + 1
			end
		end

	to_lower
			-- Convert to lower case.
		local
			i, l_count: INTEGER
			l_area: like area
		do
			l_count := count; l_area := area
			from i := 0 until i = l_count loop
				l_area.put (l_area.item (i).lower, i)
				i := i + 1
			end
		end

	to_string_32: STRING_32
		do
			create Result.make_filled ('%U', count)
			Result.area.copy_data (area, 0, 0, count)
		end

feature -- Duplication

	copy_from_other (other: EL_EXTRA_UNICODE_CHARACTERS)
		local
			l_count: INTEGER
		do
			l_count := other.count
			if l_count > capacity then
				create area.make_filled ('%U', l_count)
			else
				area.wipe_out
			end
			area.copy_data (other.area, 0, 0, l_count)
		ensure then
			same_count: count = other.count
		end

feature -- Removal

	wipe_out
			-- Remove all characters.
		do
			area.wipe_out
		end

feature {STRING_HANDLER} -- Implementation

	area: SPECIAL [CHARACTER_32]

feature -- Constants

	Default_area: SPECIAL [CHARACTER_32]
		once ("process")
			create Result.make_empty (0)
		end

	Maximum_place_holder: INTEGER = 31

	Maximum_place_holder_count: INTEGER = 26

	Replacement_character: CHARACTER_32 = '�'

end
