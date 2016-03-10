note
	description: "[
		Fast lookup of code in unencoded intervals array
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 19:23:28 GMT (Friday 18th December 2015)"
	revision: "5"

class
	EL_UNENCODED_CHARACTERS_INDEX

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			area as array_area,
			make as make_array,
			index_of as array_index_of,
			valid_index as valid_array_index,
			occurrences as interval_occurrences,
			set_area as set_array_area
		redefine
			start, back, forth
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_area: like area)
		do
			make_array (a_area.count)
			set_area (a_area)
		end

	make_default
		do
			make_array (5)
			create area.make_empty (0)
		end

feature -- Access

	code (i: INTEGER): NATURAL
		require
			valid_index: valid_index (i)
		do
			if i < item_lower then
				from until i >= item_lower loop
					back
				end
			elseif i > item_upper then
				from until i <= item_upper loop
					forth
				end
			end
			Result := area [area_index + i - item_lower]
		end

	index_of (unicode: NATURAL; start_index: INTEGER): INTEGER
		local
			i, l_lower, l_count, l_area_index: INTEGER; l_area: like area
		do
			l_area := area
			from start until Result > 0 or else after loop
				l_lower := item_lower
				if start_index <= l_lower or else start_index <= item_upper then
					l_count := item_count; l_area_index := area_index
					from i := l_lower.max (start_index) - l_lower + 1 until Result > 0 or else i > l_count loop
						if l_area [l_area_index + i - 1] = unicode then
							Result := l_lower + i - 1
						end
						i := i + 1
					end
				end
				forth
			end
		end

	z_code (i: INTEGER): NATURAL
		do
			Result := code (i)
			if Result <= 0xFF then
				-- Shift into Unicode private use area 0xE000..0xF8FF
				-- (See: See https://en.wikipedia.org/wiki/Private_Use_Areas)
				Result := Result + 0xE000
			end
		end

feature -- Measurement

	occurrences (unicode: NATURAL): INTEGER
		local
			i, limit: INTEGER; l_area: like area
		do
			l_area := area
			from start until after loop
				limit := area_index + item_count
				from i := area_index until i = limit loop
					if l_area [i] = unicode then
						Result := Result + 1
					end
					i := i + 1
				end
				forth
			end
		end

feature -- Status query

	valid_index (i: INTEGER): BOOLEAN
		local
			l_cursor: like cursor
			l_area_index: like area_index
		do
			l_cursor := cursor; l_area_index := area_index
			from start until Result or after loop
				if item_lower <= i and then i <= item_upper then
					Result := True
				end
				forth
			end
			go_to (l_cursor)
			area_index := l_area_index
		end

feature -- Cursor movement

	start
		do
			Precursor
			area_index := 2
		end

	back
		do
			Precursor; area_index := area_index - item_count - 2
		end

	forth
		do
			area_index := area_index + item_count + 2
			Precursor
		end

feature -- Element change

	set_area (a_area: like area)
		local
			i, l_lower, l_upper, area_count: INTEGER
		do
			area := a_area
			wipe_out
			area_count := a_area.count
			from i := 0 until i = area_count loop
				extend (a_area.item (i).to_integer_32, a_area.item (i + 1).to_integer_32)
				i := i + last_count + 2
			end
			start
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [NATURAL]

	area_index: INTEGER
		-- `area' index of character at `lower'

end
