note
	description: "Text aligned within a rectangle"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-08 17:48:59 GMT (Wednesday 8th July 2020)"
	revision: "1"

class
	EL_ALIGNED_TEXT

inherit
	EL_TEXT_ALIGNMENT
		rename
			alignment_code as alignment
		export
			{NONE} all
		undefine
			out
		end

	EL_RECTANGLE
		rename
			make as make_rectangle
		export
			{NONE} all
			{ANY} x, y, height, width, set_height, set_y, bottom
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: ZSTRING; rectangle: EL_TEXT_RECTANGLE)
		local
			bottom_most: INTEGER
		do
			text := a_text
			font := rectangle.font.twin
			alignment := rectangle.alignment_code
			make_rectangle (rectangle.x, rectangle.y, rectangle.width, font.line_height)

			bottom_most := rectangle.bottom_most_y
			if bottom_most > 0 then
				set_y (bottom_most + 1)
			end
		end

feature -- Element change

	align (rectangle: EL_TEXT_RECTANGLE)
		-- align text within the text `rectangle'
		local
			difference: INTEGER
		do
			if text.count > 0 and alignment /= Left_alignment then
				difference := width - font.string_width (text.to_unicode)
				inspect alignment
					when Right_alignment then
						grow_left (difference.opposite)

					when Center_alignment then
						difference := difference // 2
						grow_left (difference.opposite)
						grow_right (difference.opposite)
				else
				end
			end
			if rectangle.is_vertically_centered then
				set_y (y + rectangle.available_height // 2)
			end
		end

feature -- Basic operations

	draw (canvas: EL_DRAWABLE)
		do
			canvas.set_font (font)
			canvas.draw_text_top_left (x, y, text.to_unicode)
		end

feature -- Access

	font: EV_FONT

	text: ZSTRING

end
