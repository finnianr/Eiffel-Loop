note
	description: "Svg text button pixmap set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-22 10:05:59 GMT (Wednesday 22nd July 2020)"
	revision: "12"

deferred class
	EL_SVG_TEXT_BUTTON_PIXMAP_SET

inherit
	EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET
		rename
			make as make_pixmap_set
		redefine
			normal, new_svg_image, fill_pixmaps, set_enabled, set_disabled, svg_icon
		end

	SD_COLOR_HELPER
		undefine
			default_create
		end

	EL_MODULE_GUI

feature {NONE} -- Initialization

	make (a_icon_path_steps: like icon_path_steps; a_text: like text; a_font: like font; a_background_color: EL_COLOR)
		do
			font := a_font; text := a_text
			height := (font.line_height * relative_height).rounded
			svg_text_width := (a_font.string_width (text.to_unicode) / height * svg_height).rounded
			make_pixmap_set (a_icon_path_steps, height / Screen.vertical_resolution, a_background_color)
		end

feature -- Access

	normal: EL_STRETCHABLE_SVG_TEMPLATE_PIXMAP
		do
			Result := pixmap_table [SVG.normal]
		end

	text: ZSTRING

	font: EL_FONT

	text_color: EV_COLOR
		deferred
		end

	disabled_text_color: EV_COLOR
		deferred
		end

	text_shadow_color: EV_COLOR
		do
			Result := color_with_lightness (text_color, -0.6).twin
		end

feature -- Measurement

	height: INTEGER

	relative_height: REAL
			-- Button height relative to font height
		deferred
		end

feature -- Status setting

	set_enabled
		do
			Precursor
			draw_text
		end

	set_disabled
		do
			Precursor
			draw_text
		end

feature {NONE} -- Implementation

	fill_pixmaps (height_cms: REAL)
		do
			Precursor (height_cms)
			draw_text
		end

	draw_text
		local
			l_pixmap: like normal; l_text: READABLE_STRING_GENERAL; half_font_descent: INTEGER
			text_rect: EL_RECTANGLE
		do
			l_text := text.to_unicode
			across pixmap_table as a_pixmap loop
				l_pixmap := a_pixmap.item
				create text_rect.make_for_text (l_text, font)
				text_rect.move_center (create {EL_RECTANGLE}.make_for_widget (l_pixmap))
				half_font_descent := font.descent // 2
				text_rect.set_y (text_rect.y - half_font_descent)
				text_rect.move (text_rect.x - half_font_descent, text_rect.y)

				if attached l_pixmap.to_argb_32_buffer as buffer then
					buffer.set_font (font)

					if is_enabled then
						buffer.set_color (text_color)
					else
						buffer.set_color (disabled_text_color)
					end
					buffer.draw_text_top_left (text_rect.x, text_rect.y, l_text)

					l_pixmap.set_with_pixel_buffer (buffer)
				end
			end
		end

	svg_icon (last_step: ZSTRING; width_cms: REAL): like normal
		do
			Result := Precursor (last_step, width_cms)
			Result.set_svg_width (svg_base_width + svg_text_width)
			across svg_base_width_table as svg_width loop
				Result.set_variable (svg_width.key, svg_width.item + svg_text_width)
			end
		end

	new_svg_image (svg_path: EL_FILE_PATH; height_cms: REAL): like normal
		do
			create Result.make_with_height_cms (svg_path, height_cms, background_color)
		end

feature {NONE} -- Implementation

	svg_text_width: INTEGER
		-- text width in SVG units

	svg_height: INTEGER
		deferred
		end

	svg_base_width: INTEGER
			-- base width to which text width will be added
		deferred
		end

	svg_base_width_table: EL_HASH_TABLE [INTEGER, STRING]
			-- dependant base widths to which text width will be added
		deferred
		end

end
