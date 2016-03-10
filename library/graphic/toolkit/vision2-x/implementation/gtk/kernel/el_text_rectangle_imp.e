note
	description: "Summary description for {EL_TEXT_RECTANGLE_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 10:34:33 GMT (Wednesday 24th June 2015)"
	revision: "3"

class
	EL_TEXT_RECTANGLE_IMP

inherit
	EL_PLATFORM_IMPL
		redefine
			interface
		end

create
	make

feature -- Basic operations

	draw_rotated_on_buffer (buffer: EL_DRAWABLE_PIXEL_BUFFER; a_angle: DOUBLE)
		local
			rect: EL_RECTANGLE
			x, y: INTEGER
		do
			x := interface.x
			y := interface.y
			buffer.save
			buffer.translate (x, y)
			buffer.rotate (a_angle)
			buffer.set_antialias_best
			across interface.internal_lines as line loop
				if not line.item.is_empty then
					rect := interface.aligned_rectangle (line.item)
					buffer.set_font (line.item.font)
					buffer.draw_text_top_left (rect.x - x, rect.y - y, line.item.text.to_unicode)
				end
			end
			buffer.restore
		end

feature {NONE} -- Implementation

	interface: EL_TEXT_RECTANGLE

end
