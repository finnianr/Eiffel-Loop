note
	description: "Cairo command context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	CAIRO_COMMAND_CONTEXT

inherit
	CAIRO_SHARED_API

feature -- Commands

	arc (xc, yc, radius, angle1, angle2: DOUBLE)
		-- Adds a circular arc of the given radius to the current path. The arc is centered at (xc , yc ),
		-- begins at angle1 and proceeds in the direction of increasing angles to end at angle2 . If angle2
		-- is less than angle1 it will be progressively increased by 2*M_PI until it is greater than angle1 .

		-- If there is a current point, an initial line segment will be added to the path to connect the current
		-- point to the beginning of the arc. If this initial line is undesired, it can be avoided by calling
		-- cairo_new_sub_path() before calling cairo_arc().

		-- Angles are measured in radians. An angle of 0.0 is in the direction of the positive X axis (in user space).
		-- An angle of M_PI/2.0 radians (90 degrees) is in the direction of the positive Y axis (in user space).
		-- Angles increase in the direction from the positive X axis toward the positive Y axis. So with the default
		-- transformation matrix, angles increase in a clockwise direction.
		do
			Cairo.arc (context, xc, yc, radius, angle1, angle2)
		end

	clip
		do
			Cairo.clip (context)
		end

	close_sub_path
		do
			Cairo.close_sub_path (context)
		end

	define_sub_path
		do
			Cairo.define_sub_path (context)
		end

	fill
		do
			Cairo.fill (context)
		end

	line_to (x, y: DOUBLE)
		do
			Cairo.line_to (context, x, y)
		end

	mask (x, y: DOUBLE)
		do
			Cairo.mask_surface (context, surface.self_ptr, x, y)
		end

	move_to (x, y: DOUBLE)
		do
			Cairo.move_to (context, x, y)
		end

	paint
		do
			if opacity = 100 then
				Cairo.paint (context)
			elseif opacity > 0 then
				Cairo.paint_with_alpha (context, opacity / 100)
			end
		end

	reset_clip
		do
			Cairo.reset_clip (context)
		end

	restore
			-- restore last drawing setting state from state stack
		do
			Cairo.restore (context)
		end

	save
			-- save current drawing setting state on to a stack
		do
			Cairo.save (context)
		end

	stroke
		do
			Cairo.stroke (context)
		end

feature {NONE} -- Implementation

	context: POINTER
		deferred
		end

	opacity: INTEGER
		deferred
		end

	surface: CAIRO_SURFACE_I
		deferred
		end

end