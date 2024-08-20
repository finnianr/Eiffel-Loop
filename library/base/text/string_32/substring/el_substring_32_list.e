note
	description: "An extendible buffer for creating instances of ${EL_SUBSTRING_32_ARRAY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_SUBSTRING_32_LIST

inherit
	ARRAYED_LIST [CHARACTER_32]
		rename
			make as make_array,
			last as last_upper,
			append as list_append
		export
			{NONE} all
			{ANY} is_empty, last_upper, prunable, count
			{EL_SUBSTRING_32_CONTAINER} area
		redefine
			wipe_out
		end

	EL_ZCODE_CONVERSION undefine copy, is_equal end

	EL_SUBSTRING_32_CONTAINER
		rename
			count as substring_count
		export
			{ANY} substring_count
		undefine
			copy, is_equal, is_empty
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_array (n * 2)
			create character_area.make_empty (n * 5)
		end

feature -- Measurement

	substring_count: INTEGER
		do
			Result := count // 2
		end

	first_lower: INTEGER
		do
			Result := first.natural_32_code.to_integer_32
		end

	first_upper: INTEGER
		do
			Result := i_th (2).natural_32_code.to_integer_32
		end

feature -- Status change

	shift (n: INTEGER)
		local
			i, last_index: INTEGER; l_area: like area
			l_offset: NATURAL
		do
			l_offset := n.to_natural_32
			l_area := area; last_index := count - 1
			from i := 0 until i > last_index loop
				l_area.put (l_area [i] + l_offset, i)
				i := i + 1
			end
		end

feature -- Element change

	append (strings: EL_SUBSTRING_32_ARRAY)
		local
			additional: INTEGER_32
		do
			additional := strings.count * 2
			grow (count + additional)
			area.copy_data (strings.area, 1, area.count, additional)
			ensure_capacity (character_area, strings.character_count)
			character_area.copy_data (strings.area, 1 + additional, character_area.count, strings.character_count)
		end

	append_interval (a_area: SPECIAL [CHARACTER_32]; a_lower, a_upper, offset: INTEGER)
		local
			l_count: INTEGER
		do
			l_count := a_upper - a_lower + 1
			ensure_capacity (character_area, l_count)
			character_area.copy_data (a_area, offset, character_area.count, l_count)
			extend (a_lower.to_character_32); extend (a_upper.to_character_32)
		end

	put_character (uc: CHARACTER_32; a_index: INTEGER)
		require
			valid_index: is_empty or else a_index.to_character_32 > last_upper
		do
			ensure_capacity (character_area, 1)
			character_area.extend (uc)

			if is_empty or else a_index.to_character_32 > last_upper + 1 then
				extend (a_index.to_character_32)
				extend (a_index.to_character_32)
			else
				put_i_th (a_index.to_character_32, count)
			end
		ensure
			valid_last_upper: last_upper = a_index.to_character_32
			even_count: count \\ 2 = 0
		end

	put_unicode (a_code: NATURAL; a_index: INTEGER)
		do
			put_character (a_code.to_character_32, a_index)
		end

	put_z_code (a_z_code: NATURAL; a_index: INTEGER)
		do
			put_character (z_code_to_unicode (a_z_code).to_character_32, a_index)
		end

feature -- Transformation

	to_substring_area: like area
		do
			create Result.make_empty (count + character_area.count + 1)
			Result.extend ((count // 2).to_character_32)
			Result.copy_data (area_v2, 0, 1, count)
			Result.copy_data (character_area, 0, Result.count, character_area.count)
		end

	to_substring_array: EL_SUBSTRING_32_ARRAY
		do
			create Result.make_from_area (to_substring_area)
		end

feature -- Removal

	wipe_out
		do
			Precursor
			character_area.wipe_out
		end

feature {EL_SUBSTRING_32_CONTAINER} -- Access

	character_area: SPECIAL [CHARACTER_32]

feature {NONE} -- Implementation

	ensure_capacity (a_area: like character_area; additional_count: INTEGER)
		local
			minimal: INTEGER
		do
			if a_area.count + additional_count > a_area.capacity then
				minimal := additional_count.max (Minimal_increase)
				character_area := a_area.aliased_resized_area (a_area.count + (a_area.capacity // 2).max (minimal))
			end
		end

end