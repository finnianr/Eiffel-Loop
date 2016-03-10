note
	description: "Circular light that ligths up Green for ON and Red for OFF"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STATUS_INDICATOR_LIGHT

inherit
	WEL_CONTROL_WINDOW
		rename
			make as control_make
		redefine
			on_paint, class_background
		end

	WEL_STANDARD_COLORS
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (a_parent: WEL_WINDOW; size, a_x, a_y: INTEGER)
			-- Load the bitmaps
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
		do
			control_make (a_parent, "")
			box_size := size
			diameter := box_size - 2
			move_and_resize (a_x, a_y, Box_size, box_size, False)
		end

feature -- Access

	is_green: BOOLEAN
			-- Is the control turned on?
			
feature -- Basic operations

	set_status_on
			--
		do
			set_is_green (true)
		end
		
	set_status_off
			--
		do
			set_is_green (false)
		end

feature {NONE} -- Implementation

	set_is_green (flag: BOOLEAN)
			--
		do
			is_green := flag
			invalidate
		end

	on_paint (paint_dc: WEL_PAINT_DC; invalid_rect: WEL_RECT)
			-- Paint the bitmap according to `off'.
		local
			brush: WEL_BRUSH
			offset: INTEGER
		do
			if is_green then
				create brush.make_solid (Green)
			else				
				create brush.make_solid (Red)
			end
			offset := (Box_size - Diameter) // 2 + 1
			paint_dc.select_brush (brush)
			paint_dc.select_pen (pen)
			paint_dc.ellipse (offset, offset, Diameter, Diameter)
			
			brush.delete
		end

	class_background: WEL_DARK_GRAY_BRUSH
			-- White background
		once
			create Result.make
		end

	diameter: INTEGER

	box_size: INTEGER

	pen: WEL_PEN
			--
		once
--			create Result.make_solid (3, Black)
			create Result.make_solid (1, Dark_gray)
		end

end

