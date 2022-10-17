note
	description: "Stock colors accessible via [$source EL_MODULE_COLOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 14:01:54 GMT (Monday 17th October 2022)"
	revision: "4"

deferred class
	EL_STOCK_COLORS_I

inherit
	EV_STOCK_COLORS
		rename
			Color_dialog as Dialog,
			Color_3d_face as Face_3d,
			Color_3d_highlight as Highlight_3d,
			Color_3d_shadow as Shadow_3d,
			Color_read_only as Read_only,
			Color_read_write as Read_write,
			Default_background_color as Default_background,
			Default_foreground_color as Default_foreground
		end

	EL_MODULE_HEXADECIMAL

feature -- Access

	text_field_background: EV_COLOR
		deferred
		end

feature -- Factory

	new_html (color_code: STRING): EV_COLOR
		do
			Once_color.set_with_html (color_code)
			Result := Once_color.to_color
		end

feature -- Color code

	html_code_to_rgb_code (html_code: STRING): INTEGER
		require
			starts_with_hash: html_code.item (1) = '#'
			has_six_digits: html_code.count = 7
		do
			Result := Hexadecimal.to_integer (html_code.substring (2, 7))
		end

	rgb_code_to_html_code (rgb_code: INTEGER): STRING
			-- RGB color code as HTML color code
		do
			Result := rgb_code.to_hex_string
			Result.put ('#', 2)
			Result.remove_head (1)
		end

feature {NONE} -- Constants

	Once_color: EL_COLOR
		once
			create Result
		end

end