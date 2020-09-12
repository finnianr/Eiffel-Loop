note
	description: "Stock colors accessible via [$source EL_MODULE_COLOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-11 12:57:27 GMT (Friday 11th September 2020)"
	revision: "3"

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

feature {NONE} -- Constants

	Once_color: EL_COLOR
		once
			create Result
		end

end
