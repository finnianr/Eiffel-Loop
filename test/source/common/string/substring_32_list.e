note
	description: "A descendant of [$source SUBSTRING_32_ARRAY] that can be extended as a list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	SUBSTRING_32_LIST

inherit
	SUBSTRING_32_ARRAY
		rename
			make as make_empty
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create substring_area.make_empty (20)
			create buffer.make_empty (100)
			last_index := 1
		end

feature -- Access

	area_copy: like substring_area
		do
			create Result.make_empty (substring_area.count)
			Result.copy_data (substring_area, 0, 0, substring_area.count)
		end

feature -- Element change

	append_character (uc: CHARACTER_32; index: INTEGER)
		do
			if index = last_upper_index + 1 then
				buffer.extend (uc)
			else
				finalize
				buffer.extend (uc)
				last_index := index
			end
		end

	finalize
		do
			if buffer.count > 0 then
				append_buffer
				buffer.wipe_out
			end
		end

feature -- Removal

	wipe_out
		do
			substring_area.wipe_out
			last_index := 1
		end

feature {NONE} -- Implementation

	append_buffer
		local
			new_substring: like substring_area.item
		do
			create new_substring.make_filled (last_index.to_character_32, buffer.count + 1)
			new_substring.copy_data (buffer, 0, 1, buffer.count)
			extend (new_substring)
		end

	extend (new: like substring_area.item)
		local
			i: INTEGER; l_area: like substring_area
		do
			i := count + 1
			l_area := substring_area
			if i > l_area.capacity then
				l_area := l_area.aliased_resized_area (i + (l_area.capacity // 2).max (5))
				substring_area := l_area
			end
			l_area.extend (new)
		end

feature {NONE} -- Internal attributes

	buffer: SPECIAL [CHARACTER_32]

	last_index: INTEGER

	last_upper_index: INTEGER
		do
			Result := last_index + buffer.count - 1
		end

end