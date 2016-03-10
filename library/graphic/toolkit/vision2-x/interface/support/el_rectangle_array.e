note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_RECTANGLE_ARRAY

feature {NONE} -- Initialization

	make (count: INTEGER)
			-- 
		do
			create rectangles.make (count)
		end

feature -- Access

	index_of_rectangle_with_point (x, y: INTEGER): INTEGER
			-- 
		do
			from rectangles.start until rectangles.after or rectangles.item.has_x_y (x, y) loop
				rectangles.forth
			end
			if not rectangles.after then
				Result := rectangles.index
			end
		end

feature -- Status query

	is_point_on_a_rectangle (x, y: INTEGER): BOOLEAN
			-- 
		do
			from rectangles.start until rectangles.after or Result = true loop
				if rectangles.item.has_x_y (x, y) then
					Result := true
				end
				rectangles.forth
			end
		end

feature -- Element change

	add_rectangle (x, y, a_width, a_height: INTEGER)
			-- 
		do
			if not rectangles.full then
				rectangles.extend (
					create {EV_RECTANGLE}.make (x, y, a_width, a_height)
				)
			end
		end
		
feature {NONE} -- Implementation

	rectangles: ARRAYED_LIST [EV_RECTANGLE]

end
