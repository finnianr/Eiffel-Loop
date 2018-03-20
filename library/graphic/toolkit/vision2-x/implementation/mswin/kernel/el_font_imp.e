note
	description: "[
		Override to `EV_FONT_IMP' fixing issue of setting font height in pixels.
		This version is compiled only if ISE_C_COMPILER = msc_vc140. It scales the font
		height differently if the deployment platform is Windows 10
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 7:45:32 GMT (Monday 12th March 2018)"
	revision: "4"

class
	EL_FONT_IMP

inherit
	EL_FONT_I
		undefine
			string_size, copy_font
		redefine
			interface
		end

	EV_FONT_IMP
		redefine
			interface, height, set_height
		end

	EL_MODULE_LOG

	EL_MODULE_WINDOWS_VERSION

	EL_MODULE_SCREEN

create
	make

feature -- Access

	height: INTEGER
			-- Preferred font height measured in screen pixels.
		local
			height_proportion: DOUBLE
		do
			height_proportion := wel_font.height / (Screen.height * Pixels_to_points_factor)
			Result := (Screen.height * height_proportion).rounded
		end

feature -- Element change

	set_height (a_height: INTEGER)
			-- Set `a_height' as preferred font size in pixels.
		do
			Wel_log_font.update_by_font (wel_font)
			Wel_log_font.set_height (pixels_to_logical_pixels_y (a_height).opposite)
			wel_font.set_indirect (Wel_log_font)
		end

feature {NONE} -- Implementation

	pixels_to_logical_pixels_y (a_height: INTEGER): INTEGER
			-- Scale to approx. the same size as GTK implementation font height and adjust for user selected DPI
			-- Rendering 4.5 cm Verdana font
			-- 	On GTK 		'A' is 40 mm high
			-- 	On Windows	'A' is 44 mm high
		local
			height_proportion: DOUBLE
		do
			height_proportion := a_height / Screen.height
			Result := (Screen.height * height_proportion * Pixels_to_points_factor).rounded
		end

feature {NONE} -- Internal attributes

	interface: detachable EL_FONT note option: stable attribute end;

feature {NONE} -- Constants

	Pixels_to_points_factor: DOUBLE = 1.212

end
