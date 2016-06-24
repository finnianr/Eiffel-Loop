note
	description: "Unix implementation of `EL_TEXT_RECTANGLE_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:43:19 GMT (Friday 24th June 2016)"
	revision: "4"

class
	EL_TEXT_RECTANGLE_IMP

inherit
	EL_TEXT_RECTANGLE_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION
		undefine
			out
		end

create
	make_cms, make, make_from_rectangle

feature {NONE} -- Implementation

	draw_rotated_on_buffer (buffer: EL_DRAWABLE_PIXEL_BUFFER; a_angle: DOUBLE)
		local
			rect: EL_RECTANGLE
		do
			buffer.save
			buffer.translate (x, y)
			buffer.rotate (a_angle)
			buffer.set_antialias_best
			across internal_lines as line loop
				if not line.item.is_empty then
					rect := aligned_rectangle (line.item)
					buffer.set_font (line.item.font)
					buffer.draw_text_top_left (rect.x - x, rect.y - y, line.item.text.to_unicode)
				end
			end
			buffer.restore
		end

end
