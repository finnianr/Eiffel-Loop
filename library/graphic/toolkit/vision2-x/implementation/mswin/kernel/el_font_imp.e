note
	description: "[
		Override to EV_FONT fixing issue of setting font height in pixels
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_FONT_IMP

inherit
	EL_FONT_I
		undefine
			string_size, copy_font
		redefine
			interface, height, set_height
		end

	EV_FONT_IMP
		redefine
			interface, height, set_height
		end

create
	make

feature -- Access

	height: INTEGER
			-- Preferred font height measured in screen pixels.
		do
			Wel_log_font.update_by_font (wel_font)
			Result := mul_div (Wel_log_font.height, Normal_dpi, DPI_y).opposite
		end

feature -- Element change

	set_height (a_height_pixels: INTEGER)
			-- Set `a_height' as preferred font size in pixels.
		do
			Wel_log_font.update_by_font (wel_font)
			Wel_log_font.set_height (mul_div (a_height_pixels, DPI_y, Normal_dpi).opposite)
			wel_font.set_indirect (Wel_log_font)
		end

feature {NONE} -- Implementation

	DPI_y: INTEGER
			-- User selected vertical screen DPI
		local
			screen_dc: WEL_SCREEN_DC
		once
			create screen_dc; screen_dc.get
			Result := get_device_caps (screen_dc.item, logical_pixels_y)
			screen_dc.release
		end

	Normal_dpi: INTEGER = 96

	interface: detachable EL_FONT note option: stable attribute end;

end
