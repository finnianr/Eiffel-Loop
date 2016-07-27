note
	description: "Summary description for {EL_DRAWABLE_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:07:12 GMT (Friday 24th June 2016)"
	revision: "7"

deferred class
	EL_DRAWABLE_LABEL

inherit
	EL_DRAWABLE

	EL_WORD_WRAPPABLE

feature {NONE} -- Initialization

	make_default
		do
			make_with_text_and_font ("", create {like font})
		end

	make_with_text_and_font (a_text: like text; a_font: like font)
			--
		do
			default_create
			tile_pixmap := Default_pixmap; pixmap := Default_pixmap
			text := a_text
			align_text_left; align_text_center
			set_font_and_height (a_font)
			set_foreground_color (GUI.Black)
		end

feature -- Access

	tile_pixmap: EV_PIXMAP

	pixmap: EV_PIXMAP

	text: ZSTRING

feature -- Status query

	is_word_wrapped: BOOLEAN

feature -- Status change

	enable_word_wrapping
		do
			is_word_wrapped := True
		end

	disable_word_wrapping
		do
			is_word_wrapped := False
		end

feature -- Element change

	set_pixmap (a_pixmap: like pixmap)
			--
		do
			pixmap := a_pixmap
		end

	set_tile_pixmap (a_tile_pixmap: like tile_pixmap)
			--
		do
			tile_pixmap := a_tile_pixmap
		end

	set_text (a_text: like text)
			--
		do
			text := a_text
			redraw
		end

	set_font_and_height (a_font: EV_FONT)
		do
			set_font (a_font)
			set_minimum_height ((font.line_height * 1.5).rounded)
--			set_minimum_size (font.string_width (text) + font.maximum_width * 2, (font.line_height * 1.5).rounded)
		end

feature {NONE} -- Implementation

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
			--
		do
			clear; draw_background
			if is_word_wrapped then
				new_wrapped_text_rectangle (text).draw (Current)
			else
				new_text_rectangle (text).draw (Current)
			end
		end

	draw_background
		local
			r: EV_RECTANGLE
		do
			if pixmap /= Default_pixmap then
				draw_pixmap (0 , 0, pixmap)

			elseif tile_pixmap /= Default_pixmap then
				create r.make (0, 0, width, height)
				draw_row_of_tiles (r, tile_pixmap)
				draw_rectangle_shadows (r.x, r.y, r.width, r.height)
			end
		end

	set_minimum_height (a_height: INTEGER)
		deferred
		end

feature {NONE} -- Constants

	Default_pixmap: EL_PIXMAP
		once
			create Result
		end
end