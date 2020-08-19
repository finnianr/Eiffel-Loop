note
	description: "Svg text button pixmap set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-19 17:52:50 GMT (Wednesday 19th August 2020)"
	revision: "17"

deferred class
	EL_SVG_TEXT_BUTTON_PIXMAP_SET

inherit
	EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET
		rename
			make as make_pixmap_set
		redefine
			new_svg_image, pixmap, svg_icon
		end

	SD_COLOR_HELPER
		undefine
			copy, default_create, is_equal
		end

	EL_MODULE_GUI

feature {NONE} -- Initialization

	make (a_icon_path_steps: like icon_path_steps; a_text: like text; a_font: like font; a_background_color: EL_COLOR)
		do
			font := a_font; text := a_text
			height := (font.line_height * relative_height).rounded
			svg_text_width := (GUI.string_width (text, a_font) / height * svg_height).rounded
			make_pixmap_set (a_icon_path_steps, height / Screen.vertical_resolution, a_background_color)
		end

feature -- Access

	disabled_text_color: EV_COLOR
		deferred
		end

	font: EL_FONT

	pixmap (state: NATURAL_8): EL_PIXMAP
		-- `{EL_PIXMAP}.draw_text_top_left' not working on Windows so this is a workaround
		local
			half_font_descent: INTEGER; text_rect: EL_RECTANGLE
			buffer: CAIRO_DRAWING_AREA
		do
			buffer := Precursor (state).to_drawing_area

			create text_rect.make_for_text (text, font)
			text_rect.move_center (buffer.dimensions)
			half_font_descent := font.descent // 2
			text_rect.set_y (text_rect.y - half_font_descent)
			text_rect.move (text_rect.x - half_font_descent, text_rect.y)

			buffer.set_font (font)

			if is_enabled then
				buffer.set_color (text_color)
			else
				buffer.set_color (disabled_text_color)
			end
			buffer.draw_text_top_left (text_rect.x, text_rect.y, text)
			Result := buffer.to_pixmap
		end

	text: READABLE_STRING_GENERAL

	text_color: EV_COLOR
		deferred
		end

feature -- Measurement

	height: INTEGER

	relative_height: REAL
			-- Button height relative to font height
		deferred
		end

feature {NONE} -- Implementation

	svg_icon (a_state: NATURAL_8; width_cms: REAL): like new_svg_image
		do
			Result := Precursor (a_state, width_cms)
			Result.set_svg_width (svg_base_width + svg_text_width)
			across svg_base_width_table as svg_width loop
				Result.set_variable (svg_width.key, svg_width.item + svg_text_width)
			end
		end

feature {NONE} -- Implementation

	lighter_text_color: EV_COLOR
		do
			Result := color_with_lightness (text_color, Lightness_proportion).twin
		end

	new_svg_image (svg_path: EL_FILE_PATH; height_cms: REAL): EL_STRETCHABLE_SVG_TEMPLATE_PIXMAP
		do
			create Result.make_with_height_cms (svg_path, height_cms, background_color)
		end

	svg_base_width: INTEGER
			-- base width to which text width will be added
		deferred
		end

	svg_base_width_table: EL_HASH_TABLE [INTEGER, STRING]
			-- dependant base widths to which text width will be added
		deferred
		end

	svg_height: INTEGER
		deferred
		end

feature {NONE} -- Internal attributes

	svg_text_width: INTEGER
		-- text width in SVG units

feature {NONE} -- Constants

	Lightness_proportion: REAL
		once
			Result := 0.5
		end

end
