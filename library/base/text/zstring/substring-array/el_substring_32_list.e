note
	description: "An extendible buffer for creating instances of [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-27 9:25:51 GMT (Wednesday 27th January 2021)"
	revision: "3"

class
	EL_SUBSTRING_32_LIST

inherit
	ARRAYED_LIST [NATURAL]
		rename
			make as make_array,
			last as last_upper
		export
			{NONE} all
			{ANY} is_empty, last_upper, prunable
		redefine
			wipe_out
		end

	EL_ZCODE_CONVERSION undefine copy, is_equal end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_array (n * 2)
			create character_list.make_empty (n * 5)
		end

feature -- Element change

	append_interval (a_area: SPECIAL [NATURAL]; a_lower, a_upper, offset: INTEGER)
		local
			l_count: INTEGER
		do
			l_count := a_upper - a_lower + 1
			ensure_capacity (character_list, l_count)
			character_list.copy_data (a_area, offset, character_list.count, l_count)
			extend (a_lower.to_natural_32); extend (a_upper.to_natural_32)
		end

	put_character (c: CHARACTER_32; a_index: INTEGER)
		do
			put_unicode (c.natural_32_code, a_index)
		end

	put_unicode (uc: NATURAL; a_index: INTEGER)
		require
			valid_index: is_empty or else a_index.to_natural_32 > last_upper
		do
			ensure_capacity (character_list, 1)
			character_list.extend (uc)

			if is_empty or else a_index.to_natural_32 > last_upper + 1 then
				extend (a_index.to_natural_32)
				extend (a_index.to_natural_32)
			else
				put_i_th (a_index.to_natural_32, count)
			end
		ensure
			valid_last_upper: last_upper = a_index.to_natural_32
			even_count: count \\ 2 = 0
		end


	put_z_code (a_z_code: NATURAL; a_index: INTEGER)
		do
			put_unicode (z_code_to_unicode (a_z_code), a_index)
		end

feature -- Transformation

	to_substring_area: like area
		do
			create Result.make_empty (count + character_list.count + 1)
			Result.extend (count.to_natural_32 // 2)
			Result.copy_data (area_v2, 0, 1, count)
			Result.copy_data (character_list, 0, Result.count, character_list.count)
		end

feature -- Removal

	wipe_out
		do
			Precursor
			character_list.wipe_out
		end

feature {NONE} -- Implementation

	ensure_capacity (a_area: like character_list; additional_count: INTEGER)
		local
			minimal: INTEGER
		do
			if a_area.count + additional_count > a_area.capacity then
				minimal := additional_count.max (Minimal_increase)
				character_list := a_area.aliased_resized_area (a_area.count + (a_area.capacity // 2).max (minimal))
			end
		end

feature {NONE} -- Internal attributes

	character_list: SPECIAL [NATURAL]

end