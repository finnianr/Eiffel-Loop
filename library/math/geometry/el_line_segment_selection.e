note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_LINE_SEGMENT_SELECTION

inherit
	EL_GRAPH_SCALE
		rename
			make as make_from_segment,
			lower as start_pos,
			upper as end_pos,
			set_position as set_segment_start_pos,
			position as segment_start_pos
		undefine
			is_equal
		end

	COMPARABLE
		undefine
			copy
		end

create
	make

feature {NONE} -- Initialization

	make (width: INTEGER)
			--
		do
			make_from_segment (0, width - 1)
		end

feature -- Element change

	set_segment_end_pos (a_segment_end_pos: INTEGER)
			--
		do
			segment_end_pos := a_segment_end_pos
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		require else
			other_is_same_dimension: start_pos = other.start_pos and end_pos = other.end_pos
		do
			if segment_start_pos < other.segment_start_pos then
				Result := true
			end
		end

feature -- Measurement

	relative_segment_length: REAL
			--
		do
			Result := ((segment_end_pos - segment_start_pos + 1) / length).rounded
		end

	segment_end_pos: INTEGER

end
