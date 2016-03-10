note
	description: "Summary description for {EL_TEXT_RECTANGLE_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 11:48:04 GMT (Wednesday 24th June 2015)"
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
			text_group: like interface.line_text_group
			line: like interface.Type_line
		do
			text_group := interface.line_text_group
			text_group.rotate_around (a_angle, interface.x, interface.y)
			across text_group as text_point loop
				line := interface.internal_lines [text_point.cursor_index]
				if not line.text.is_empty and then attached {EV_MODEL_DOT} text_point.item as point then
					buffer.set_font (line.font)
					buffer.draw_rotated_text_top_left (point.x, point.y, a_angle, line.text.to_unicode)
				end
			end
		end

feature {NONE} -- Implementation

	interface: EL_TEXT_RECTANGLE

end
