note
	description: "An extendible buffer for creating instances of [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-28 17:32:14 GMT (Monday 28th December 2020)"
	revision: "1"

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

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_array (n * 2)
			create character_list.make (n * 5)
		end

feature -- Element change

	put_character (uc: CHARACTER_32; a_index: INTEGER)
		require
			valid_index: is_empty or else a_index.to_natural_32 > last_upper
		do
			character_list.extend (uc.natural_32_code)
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

feature -- Transformation

	to_substring_area: like area
		do
			create Result.make_empty (count + character_list.count + 1)
			Result.extend (count.to_natural_32 // 2)
			Result.copy_data (area_v2, 0, 1, count)
			Result.copy_data (character_list.area_v2, 0, Result.count, character_list.count)
		end

feature -- Removal

	wipe_out
		do
			Precursor
			character_list.wipe_out
		end

feature {NONE} -- Internal attributes

	character_list: ARRAYED_LIST [NATURAL]

end