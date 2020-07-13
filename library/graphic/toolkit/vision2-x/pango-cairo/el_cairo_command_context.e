note
	description: "Cairo command context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 9:32:21 GMT (Monday 13th July 2020)"
	revision: "1"

deferred class
	EL_CAIRO_COMMAND_CONTEXT

inherit
	EL_SHARED_CAIRO_API

feature -- Commands

	arc (xc, yc, radius, angle1, angle2: DOUBLE)
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

	surface: EL_CAIRO_SURFACE_I
		deferred
		end

end
