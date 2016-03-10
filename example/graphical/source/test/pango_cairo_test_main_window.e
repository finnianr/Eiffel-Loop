note
	description: "Summary description for {TEST_WINDOW}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 18:21:56 GMT (Saturday 26th December 2015)"
	revision: "5"

class
	PANGO_CAIRO_TEST_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW
		redefine
			make
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create, copy, is_equal
		end

	MATH_CONST
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			size_drop_down: EL_DROP_DOWN_BOX [REAL]; font_list_drop_down: EL_ZSTRING_DROP_DOWN_BOX
			text_angle_drop_down: EL_DROP_DOWN_BOX [INTEGER]
			cell: EV_CELL; l_pixmap: EL_PIXMAP
			picture_box: EL_HORIZONTAL_BOX
		do
			Precursor
			set_dimensions
			set_title ("Test Window")
			font_size := 0.5
			create size_drop_down.make (font_size, Font_sizes, agent set_font_size)

--			font_family := "Verdana"
--			font_family := "Courier 10 Pitch"
			font_family := "Garuda"
			create font_list_drop_down.make (font_family, GUI.General_font_families, agent set_font_family)

			text_angle := 0
			create text_angle_drop_down.make (text_angle, << 0, 90 >>, agent set_text_angle)

			create cell
			l_pixmap := lenna_pixmap
			cell.set_minimum_size (l_pixmap.width, l_pixmap.height)

			create pixmap_cell.make_with_container (cell, agent new_pixmap)
			picture_box := GUI.horizontal_box (0.3, 0.0, << cell >>)
			picture_box.set_background_color (GUI.White)
			extend (
				GUI.vertical_box (0.1, 0.1, <<
					picture_box,
					GUI.horizontal_box (0.2, 0.1, <<
						GUI.label ("Font:"), font_list_drop_down,
						GUI.label ("Size:"), size_drop_down,
						GUI.label ("Angle:"), text_angle_drop_down,
						create {EL_EXPANDED_CELL}
					>>)
				>>)
			)
			set_position (100, 100)
		end

feature {NONE} -- Element change

	set_font_size (a_font_size: like font_size)
		do
			font_size := a_font_size
			GUI.do_once_on_idle (agent pixmap_cell.update)
		end

	set_text_angle (a_text_angle: like text_angle)
		do
			text_angle := a_text_angle
			GUI.do_once_on_idle (agent pixmap_cell.update)
		end

	set_font_family (a_font_family: like font_family)
		do
			font_family := a_font_family
			GUI.do_once_on_idle (agent pixmap_cell.update)
		end

feature {NONE} -- Implementation

	new_pixmap: EL_PIXMAP
		do
			Result := new_pixel_buffer (GUI.font_regular (font_family.to_latin_1, font_size)).to_pixmap
		end

	new_pixel_buffer (title_font: EL_FONT): EL_DRAWABLE_PIXEL_BUFFER
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

			l_pixmap := lenna_pixmap
			l_pixmap.set_foreground_color (GUI.White)
			l_pixmap.set_line_width (1)

			l_pixmap.draw_rectangle (name_rect.x, name_rect.y, name_rect.width, name_rect.height)
			l_pixmap.set_font (title_font)
			if text_angle = 0 then
				l_pixmap.draw_text_top_left (name_rect.x, name_rect.y, l_title)
			else
				l_pixmap.implementation.draw_rotated_text (
					name_rect.x + title_font.descent, name_rect.y, Pi_2.opposite.truncated_to_real, l_title
				)
			end

			if text_angle = 0 then
				name_rect.set_y (name_rect.y + name_rect.height - 1)
			else
				name_rect.set_x (name_rect.x + name_rect.width - 1)
			end
			l_pixmap.draw_rectangle (name_rect.x, name_rect.y, name_rect.width, name_rect.height)

--			create Result.make_with_pixmap (l_pixmap) -- _rgb_24
			create Result.make_with_size (l_pixmap.width, l_pixmap.height) -- _rgb_24

--			Result.lock

			Result.set_color (GUI.White)
			Result.fill_rectangle (0, 0, l_pixmap.width, l_pixmap.height)
			Result.draw_rounded_pixmap (0, 0, 35, l_pixmap)
--			Result.draw_pixmap (0, 0, l_pixmap)
			Result.set_font (title_font)
			if text_angle = 0 then
				Result.draw_text_top_left (name_rect.x, name_rect.y, l_title)
			else
				Result.draw_rotated_text_top_left (name_rect.x + name_rect.width, name_rect.y, Pi_2, l_title)
			end
--			Result.unlock

		end

	new_pixmap_cell (a_pixmap: EV_PIXMAP): EV_CELL
		do
			create Result
			Result.put (a_pixmap)
			Result.set_minimum_size (a_pixmap.width, a_pixmap.height)
		end

	lenna_pixmap: EL_PIXMAP
		do
			create Result
			Result.set_with_named_file (
				Execution.variable_dir_path ("ISE_EIFFEL").joined_file_path ("library/vision2/tests/graphics/Lenna.png").unicode
			)
		end

	set_dimensions
		do
		end

	pixmap_cell: EL_MANAGED_WIDGET [EL_PIXMAP]

	font_size: REAL

	font_family: ZSTRING

	text_angle: INTEGER

feature {NONE} -- Constants

	Font_sizes: ARRAY [REAL]
		once
			Result := << 0.5, 1.25, 1.5 >>
		end

end
