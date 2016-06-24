note
	description: "Windows implementation of `EL_TEXT_RECTANGLE_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:46:15 GMT (Friday 24th June 2016)"
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
			line: like internal_lines
		do
			line_text_group.rotate_around (a_angle, interface.x, interface.y)
			across line_text_group as text_point loop
				line := internal_lines [text_point.cursor_index]
				if not line.text.is_empty and then attached {EV_MODEL_DOT} text_point.item as point then
					buffer.set_font (line.font)
					buffer.draw_rotated_text_top_left (point.x, point.y, a_angle, line.text.to_unicode)
				end
			end
		end

end
