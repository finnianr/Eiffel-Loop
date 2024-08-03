note
	description: "Pango cairo test main window"
	notes: "[
		**Demonstrates**
		
		1. Replaceable widgets
		2. Class ${EL_BOOLEAN_ITEM_RADIO_BUTTON_GROUP}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-03 13:23:37 GMT (Saturday 3rd August 2024)"
	revision: "36"

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

	EL_REPLACEABLE_WIDGET_ITEM_2
		rename
			item as font_drop_down,
			new_item as new_font_drop_down,
			replace_item as replace_font_drop_down
		end

	EL_GEOMETRY_MATH
		rename
			log as natural_log
		undefine
			default_create, copy, is_equal
		end

	EL_FONT_PROPERTY
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	EL_MODULE_COLOR; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_SCREEN; EL_MODULE_TEXT

	EL_MODULE_VISION_2; EL_MODULE_WIDGET

	EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		local
			cell: EV_CELL; l_pixmap: EL_PIXMAP
		do
			Precursor
			set_dimensions
			set_title ("Test Window")
			font_width_bitmap := Font_proportional; font_type_bitmap := Font_true_type
			font_size := Font_sizes [2]; text_angle := 0
			font_family := default_font_family
			create cell
			create l_pixmap.make_from_other (Lenna_pixmap)
			cell.set_minimum_size (l_pixmap.width, l_pixmap.height)

			pixmap := new_pixmap; font_drop_down := new_font_drop_down
			cell.put (pixmap)
			if attached Vision_2 as v then
				picture_box := v.new_horizontal_box (0.5, 0.0, << create {EL_EXPANDED_CELL}, cell,  create {EL_EXPANDED_CELL} >>)
				picture_box.set_background_color (Color.White)
				picture_box.propagate_background_color
				extend (v.new_vertical_box (0.1, 0.1, << picture_box, new_style_options_box, new_font_box >>) )
			end
			Screen.set_position (Current, 100, 100)
			Action.do_later (500, agent check_pixel_color)
			Action.do_once_on_idle (agent display_fonts)
		end

feature {NONE} -- Element change

	set_font_family (a_font_family: ZSTRING)
		do
			font_family := a_font_family.to_string_8
			Action.do_once_on_idle (agent replace_pixmap)
		end

	set_font_size (a_font_size: like font_size)
		do
			font_size := a_font_size
			Action.do_once_on_idle (agent replace_pixmap)
		end

	set_text_angle (a_text_angle: like text_angle)
		do
			text_angle := a_text_angle
			Action.do_once_on_idle (agent replace_pixmap)
		end

feature {NONE} -- Factory

	new_drawing_area (title_font: EL_FONT): CAIRO_DRAWING_AREA
		local
			name_rect: EL_RECTANGLE; l_pixmap: EL_PIXMAP
			l_title: STRING
		do
			l_title := "Aa: " + title_font.name
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
			Result.draw_rounded_pixmap (
				0, 0, 35, Top_left_corner | Top_right_corner | Bottom_right_corner | Bottom_left_corner, l_pixmap
			)
			Result.set_font (title_font)
		-- Draw text with Pango-Cairo
			if text_angle = 0 then
				Result.draw_text_top_left (name_rect.x, name_rect.y, l_title)
			else
				Result.draw_rotated_text_top_left (name_rect.x + name_rect.width, name_rect.y, Radian_90, l_title)
			end
		end

	new_font_box: EL_HORIZONTAL_BOX
			--
		local
			text_angle_drop_down: EL_DROP_DOWN_BOX [INTEGER]
			size_drop_down: EL_DROP_DOWN_BOX [REAL]
		do
			create size_drop_down.make (font_size, Font_sizes, agent set_font_size)
			create text_angle_drop_down.make (text_angle, << 0, 90 >>, agent set_text_angle)
			if attached Vision_2 as v then
				create Result.make_unexpanded (0.2, 0.3, <<
					v.new_label_bold ("Fonts:"), font_drop_down,
					v.new_label_bold ("Size:"), size_drop_down,
					v.new_label_bold ("Angle:"), text_angle_drop_down,
					v.new_button ("TEST", agent on_test)
				>>)
			end
		end

	new_font_drop_down: EL_FONT_FAMILY_DROP_DOWN_BOX
		do
			create Result.make (font_family, new_font_query, agent set_font_family)
		end

	new_font_query: EL_COMPACT_ZSTRING_LIST
		do
			Result := Text.Pango_font_families.new_query_list (font_width_bitmap, font_type_bitmap, excluded_char_sets)
		end

	new_style_options_box: EL_HORIZONTAL_BOX
			--
		local
			width_group, type_group: EL_BOOLEAN_ITEM_RADIO_BUTTON_GROUP
		do
			create width_group.make (True, "Monospace", "Proportional", agent on_font_width)
			create type_group.make (True, "no", "yes", agent on_font_type)
			create Result.make_unexpanded (0.2, 0.2, <<
				Vision_2.new_label_bold ("Font width:"), width_group.horizontal_box (0, 0),
				create {EV_VERTICAL_SEPARATOR},
				Vision_2.new_label_bold ("True type fonts:"), type_group.horizontal_box (0, 0)
			>>)
		end

	new_pixmap: EL_PIXMAP
		do
			Result := new_drawing_area (Vision_2.new_font_regular (font_family, font_size)).to_pixmap
		end

	new_pixmap_cell (a_pixmap: EV_PIXMAP): EV_CELL
		do
			create Result
			Result.put (a_pixmap)
			Result.set_minimum_size (a_pixmap.width, a_pixmap.height)
		end

feature {NONE} -- Event handling

	on_font_width (is_proportional: BOOLEAN)
		do
			if is_proportional then
				font_width_bitmap := Font_proportional
			else
				font_width_bitmap := Font_monospace
			end
			on_style_change
		end

	on_font_type (is_true_type: BOOLEAN)
		do
			if is_true_type then
				font_type_bitmap := Font_true_type
			else
				font_type_bitmap := Font_non_true_type
			end
			on_style_change
		end

	on_test
		local
			dialog: UNTITLED_DIALOG; close_button: EV_BUTTON
		do
			create dialog
			create close_button.make_with_text_and_action ("Close", agent dialog.destroy)
			dialog.extend (close_button)
			dialog.set_default_cancel_button (close_button)
			dialog.show_modal_to_window (Current)
		end

	on_style_change
		do
			font_family := default_font_family
			replace_font_drop_down; replace_pixmap
			Action.do_once_on_idle (agent display_fonts)
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
			lio.put_new_line
		end

	default_font_family: STRING
		do
			if {PLATFORM}.is_windows then
				if font_width_bitmap = Font_proportional then
					if font_type_bitmap = Font_true_type then
						Result := "Arial"
					else
						Result := "DejaVu Sans Light"
					end
				else
					if font_type_bitmap = Font_true_type then
						Result := "Courier New"
					else
						Result := "@SimHei"
					end
				end
			else -- Linux GTK
				if font_width_bitmap = Font_proportional then
					if font_type_bitmap = Font_true_type then
						Result := "Serif"
					else
						Result := "Bitstream Charter"
					end
				else
					if font_type_bitmap = Font_true_type then
						Result := "FreeMono"
					else
						Result := "Monospace"
					end
				end
			end
		end

	display_fonts
		do
			lio.put_integer_field ("EL_FONT_FAMILIES_I memory saving", Text.Font_families.space_saving_percent)
			lio.put_character ('%%')
			lio.put_new_line_x2
			lio.put_labeled_string ("Selected family", font_family)
			lio.put_new_line
			across new_font_query as family loop
				lio.put_string (family.item); lio.put_string (Space * (25 - family.item.count))
				if family.cursor_index \\ 4 = 0 then
					lio.put_new_line
				end
			end
			lio.put_new_line_x2
		end

	excluded_char_sets: ARRAY [INTEGER]
		do
			if {PLATFORM}.is_windows then
			-- SWGamekeys MT, Symbol, Webdings, Wingdings: cause Pango output error "not-rotated" "ugly-output"
			-- {WEL_CHARACTER_SET_CONSTANTS} Symbol_charset: INTEGER = 2
				Result := << 2 >>
			else
				create Result.make_empty
			end
		end

	set_dimensions
		do
		end

feature {NONE} -- Internal attributes

	font_family: STRING

	font_size: REAL

	font_type_bitmap: NATURAL_8

	font_width_bitmap: NATURAL_8

	picture_box: EL_HORIZONTAL_BOX

	text_angle: INTEGER

feature {NONE} -- Constants

	Font_sizes: ARRAY [REAL]
		once
			Result := << 0.5, 1.25, 1.5 >>
		end

	Lenna_pixmap: EL_PIXMAP
		local
			lenna_path: FILE_PATH
		once
			lenna_path := "$ISE_EIFFEL/library/vision2/tests/graphics/Lenna.png"
			lenna_path.expand
			create Result
			Result.set_with_named_file (lenna_path)
		end

end