note
	description: "[
		List of all occurrence intervals of a `search_string' in a string conforming to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-22 15:01:58 GMT (Sunday 22nd August 2021)"
	revision: "10"

class
	EL_OCCURRENCE_INTERVALS [S -> STRING_GENERAL create make end]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_intervals,
			fill as fill_from
		export
			{NONE} extend, item_extend, item_replace
		redefine
			make_empty
		end

create
	make, make_empty, make_with_character

feature {NONE} -- Initialization

	make_with_character (a_string: S; search_character: CHARACTER_32)
		local
			s: EL_STRING_32_ROUTINES
		do
			make (a_string, s.character_string (search_character))
		end

	make (a_string: S; search_string: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill (a_string, search_string)
		end

	make_empty
		do
			area_v2 := Default_area
		end

feature -- Basic operations

	fill (a_string: S; search_string: READABLE_STRING_GENERAL)
		local
			i, string_count, search_string_count, search_index: INTEGER
			search_character: like new_target.item
			buffer: like Intervals_buffer
		do
			buffer := Intervals_buffer
			buffer.wipe_out

			search_character := search_string [1]
			string_count := a_string.count; search_string_count := search_string.count
			from i := 1 until i = 0 or else i > string_count - search_string_count + 1 loop
				if search_string_count = 1 then
					i := a_string.index_of (search_character, i)
				else
					i := a_string.substring_index (search_string, i)
				end
				if i > 0 then
					search_index := i
					extend_buffer (buffer, search_index, search_string_count, False)
					i := i + search_string_count
				end
			end
			extend_buffer (buffer, search_index, search_string_count, True)
			make_intervals (buffer.count)
			area.copy_data (buffer.area, 0, 0, buffer.count)
		end

feature {NONE} -- Implementation

	extend_buffer (buffer: like Intervals_buffer; search_index, search_string_count: INTEGER; final: BOOLEAN)
		do
			if not final then
				buffer.extend (new_item (search_index, search_index + search_string_count - 1))
			end
		end

	new_target: S
		do
			create Result.make (0)
		end

feature {NONE} -- Constants

	Default_area: SPECIAL [INTEGER_64]
		once
			create Result.make_empty (0)
		end

	Intervals_buffer: ARRAYED_LIST [INTEGER_64]
		once
			create Result.make (50)
		end
end