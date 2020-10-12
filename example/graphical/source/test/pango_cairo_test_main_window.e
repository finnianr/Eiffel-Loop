note
	description: "Pango cairo test main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-12 15:11:05 GMT (Monday 12th October 2020)"
	revision: "17"

class
	PANGO_CAIRO_TEST_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW
		redefine
			make
		end

	EL_REPLACEABLE_WIDGET_ITEM
		rename
			item as pixmap,
			new_item as new_pixmap,
			replace_item as replace_pixmap
		end

	EL_GEOMETRY_MATH
		rename
			log as natural_log
		undefine
			default_create, copy, is_equal
		end

	EL_DIRECTION
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_COLOR

	EL_MODULE_SCREEN

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make
		local
			size_drop_down: EL_DROP_DOWN_BOX [REAL]; font_list_drop_down: EL_ZSTRING_DROP_DOWN_BOX
			text_angle_drop_down: EL_DROP_DOWN_BOX [INTEGER]
			cell: EV_CELL; l_pixmap: EL_PIXMAP
		do
			Precursor
			set_dimensions
			set_title ("Test Window")
			font_size := 0.5
			create size_drop_down.make (font_size, Font_sizes, agent set_font_size)

			font_family := "Verdana"
--			font_family := "Courier 10 Pitch"
--			font_family := "Garuda"
			create font_list_drop_down.make (font_family, GUI.General_font_families, agent set_font_family)

			text_angle := 0
			create text_angle_drop_down.make (text_angle, << 0, 90 >>, agent set_text_angle)

			create cell
			create l_pixmap.make_from_other (Lenna_pixmap)
			cell.set_minimum_size (l_pixmap.width, l_pixmap.height)

			pixmap := new_pixmap
			cell.put (pixmap)
			picture_box := Vision_2.new_horizontal_box (0.3, 0.0, << cell >>)
			picture_box.set_background_color (Color.White)
			extend (
				Vision_2.new_vertical_box (0.1, 0.1, <<
					picture_box,
					Vision_2.new_horizontal_box (0.2, 0.1, <<
						Vision_2.new_label ("Font:"), font_list_drop_down,
						Vision_2.new_label ("Size:"), size_drop_down,
						Vision_2.new_label ("Angle:"), text_angle_drop_down,
						create {EL_EXPANDED_CELL}
					>>)
				>>)
			)
			Screen.set_position (Current, 100, 100)
			GUI.do_later (500, agent check_pixel_color)
		end

feature {NONE} -- Element change

	set_font_family (a_font_family: like font_family)
		do
			font_family := a_font_family
			GUI.do_once_on_idle (agent replace_pixmap)
		end

	set_font_size (a_font_size: like font_size)
		do
			font_size := a_font_size
			GUI.do_once_on_idle (agent replace_pixmap)
		end

	set_text_angle (a_text_angle: like text_angle)
		do
			text_angle := a_text_angle
			GUI.do_once_on_idle (agent replace_pixmap)
		end

feature {NONE} -- Factory

	new_drawing_area (title_font: EL_FONT): CAIRO_DRAWING_AREA
		local
			name_rect: EL_RECTANGLE; l_pixmap: EL_PIXMAP
			l_title: STRING
		do
			l_title := "Font: " + title_font.name
			create name_rect.make_for_text (l_title, title_font)
			if text_angle = 90 then
				create name_rect.make (0, 0, name_rect.height, name_rect.width)
			end
			name_rect.move (10, 60)

			create l_pixmap.make_from_other (Lenna_pixmap)
			l_pixmap.set_foreground_color (Color.White)
			l_pixmap.set_line_width (1)

			l_pixmap.draw_rectangle (name_rect.x, name_rect.y, name_rect.width, name_rect.height)
			l_pixmap.set_font (title_font)
			if text_angle = 0 then
				l_pixmap.draw_text_top_left (name_rect.x, name_rect.y, l_title)
			else
				l_pixmap.implementation.draw_rotated_text (
					name_rect.x + title_font.descent, name_rect.y, radians (90).opposite.truncated_to_real, l_title
				)
			end

			if text_angle = 0 then
				name_rect.set_y (name_rect.y + name_rect.height - 1)
			else
				name_rect.set_x (name_rect.x + name_rect.width - 1)
			end
			l_pixmap.draw_rectangle (name_rect.x, name_rect.y, name_rect.width, name_rect.height)

			create Result.make_with_size (l_pixmap.width, l_pixmap.height) -- _rgb_24

			Result.set_color (Color.White)
			Result.fill_rectangle (0, 0, l_pixmap.width, l_pixmap.height)
			Result.draw_rounded_pixmap (0, 0, 35, Top_left | Top_right | Bottom_right | Bottom_left, l_pixmap)
			Result.set_font (title_font)
			if text_angle = 0 then
				Result.draw_text_top_left (name_rect.x, name_rect.y, l_title)
			else
				Result.draw_rotated_text_top_left (name_rect.x + name_rect.width, name_rect.y, Pi_2, l_title)
			end
		end

	new_pixmap: EL_PIXMAP
		do
			Result := new_drawing_area (Vision_2.new_font_regular (font_family.to_latin_1, font_size)).to_pixmap
		end

	new_pixmap_cell (a_pixmap: EV_PIXMAP): EV_CELL
		do
			create Result
			Result.put (a_pixmap)
			Result.set_minimum_size (a_pixmap.width, a_pixmap.height)
		end

feature {NONE} -- Implementation

	check_pixel_color
		local
			assertion: STRING
		do
			assertion := "Screen.color_at_pixel (picture_box, 1, 1).is_equal (Color.White)"
			if not Screen.color_at_pixel (picture_box, 1, 1).is_equal (Color.White) then
			 assertion.prepend ("not ")
			end
			lio.put_line (assertion)
		end

	set_dimensions
		do
		end

feature {NONE} -- Internal attributes

	font_family: ZSTRING

	font_size: REAL

	text_angle: INTEGER

	picture_box: EL_HORIZONTAL_BOX

feature {NONE} -- Constants

	Font_sizes: ARRAY [REAL]
		once
			Result := << 0.5, 1.25, 1.5 >>
		end

	Lenna_pixmap: EL_PIXMAP
		local
			lenna_path: EL_FILE_PATH
		once
			lenna_path := "$ISE_EIFFEL/library/vision2/tests/graphics/Lenna.png"
			lenna_path.expand
			create Result
			Result.set_with_named_file (lenna_path)
		end

end