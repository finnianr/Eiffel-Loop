note
	description: "An [$source EL_UNICODE_SUBSTRINGS] object that can be extended"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-04 17:15:45 GMT (Friday 4th December 2020)"
	revision: "2"

class
	EL_EXTENDABLE_UNICODE_SUBSTRINGS

inherit
	EL_UNICODE_SUBSTRINGS
		rename
			make as make_empty
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create substring_area.make_empty (20)
			create buffer.make (100)
			last_index := 1
		end

feature -- Access

	area_copy: like substring_area
		do
			create Result.make_empty (substring_area.count)
			Result.copy_data (substring_area, 0, 0, substring_area.count)
		end

feature -- Element change

	append_code (a_code: NATURAL; index: INTEGER)
		do
			if index = last_upper_index + 1 then
				buffer.append_code (a_code)
			else
				finalize
				buffer.append_code (a_code)
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
			new_substring.copy_data (buffer.area, 0, 1, buffer.count)
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

	buffer: STRING_32

	last_index: INTEGER

	last_upper_index: INTEGER
		do
			Result := last_index + buffer.count - 1
		end

end