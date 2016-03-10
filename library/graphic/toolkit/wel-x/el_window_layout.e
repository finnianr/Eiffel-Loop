note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_WINDOW_LAYOUT

feature {NONE} -- Initialization

	make_window_layout (a_width, a_height: INTEGER)
			--
		do
			create layout_pos.make (Border_left_right, Border_top_bottom)
			create layout_size.make (0, 0)

			resize (a_width, a_height)
		end

feature {NONE} -- Basic operations

	layout_next_row
			--
		do
			layout_pos.set_y (layout_pos.y + layout_size.height + Field_spacing)
		end

	layout_next_control
			--
		do
			layout_pos.set_x (layout_pos.x + layout_size.width + Field_spacing)
		end

feature {NONE} -- Implementation

	resize (a_width, a_height: INTEGER)
			-- Resize the window with `a_width', `a_height'.
		deferred
		end

	layout_pos: WEL_POINT

	layout_size: WEL_SIZE


feature {NONE} -- Constants

	Field_spacing: INTEGER
			--
		deferred
		end
	
	Border_left_right: INTEGER
			--
		deferred
		end
	
	Border_top_bottom: INTEGER
			--
		deferred
		end
		
invariant
	layout_pos_set: layout_pos /= Void
	layout_size_set: layout_size /= Void

end


