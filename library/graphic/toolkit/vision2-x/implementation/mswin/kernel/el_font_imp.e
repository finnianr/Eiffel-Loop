note
	description: "[
		Override to `EV_FONT_IMP' fixing issue of setting font height in pixels
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-17 9:08:13 GMT (Monday 17th October 2016)"
	revision: "2"

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

--	EL_MODULE_LOG

	EL_MODULE_WINDOWS

create
	make

feature -- Access

	height: INTEGER
			-- Preferred font height measured in screen pixels.
		local
			height_proportion: DOUBLE
		do
			if Windows.major_version >= 10 then
				height_proportion := wel_font.height / (Screen.height * Pixels_to_points_factor)
			else
				height_proportion := wel_font.height / (Fantasy_screen_height_pixels * GTK_scale)
			end
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
--			log.enter_with_args ("pixels_to_logical_pixels_y", << a_height >>)
			height_proportion := a_height / Screen.height

--			log.put_double_field ("height_proportion", height_proportion)
--			log.put_double_field (" Screen height", Screen.height)
--			log.put_double_field (" in cms", Screen.height_cms)

			if Windows.major_version >= 10 then
				Result := (Screen.height * height_proportion * Pixels_to_points_factor).rounded
			else
				Result := (Fantasy_screen_height_pixels * height_proportion * GTK_scale).rounded
--				log.put_double_field ("fantasy_screen_height_pixels", fantasy_screen_height_pixels)
--				log.put_new_line
			end

--			log.put_integer_field ("Result", Result)
--			log.exit
		end

feature {NONE} -- Internal attributes

	interface: detachable EL_FONT note option: stable attribute end;

feature {NONE} -- Constants

	Fantasy_screen_height_pixels: DOUBLE
		local
			dc: WEL_SCREEN_DC; dots_per_cm, fantasy_screen_height_cms: DOUBLE; dpi: INTEGER
		once
			create dc; dc.get
			dpi := get_device_caps (dc.item, logical_pixels_y)
--			log.put_integer_field (" dpi", dpi)
--			log.put_new_line
			dots_per_cm := dpi * 96 / (dpi * 2.54) -- Scale to 96 DPI in metric units
			fantasy_screen_height_cms := get_device_caps (dc.item, Vertical_size) / 10
--			log.put_double_field ("fantasy_screen_height_cms", fantasy_screen_height_cms)
--			log.put_new_line
--			log.put_double_field (" dots_per_cm", dots_per_cm)
--			log.put_new_line
			dc.release
			Result := fantasy_screen_height_cms * dots_per_cm
		end

	Pixels_to_points_factor: DOUBLE = 1.212

	GTK_scale: DOUBLE
			-- Rendering 4.5 cm Verdana font
			-- 	On GTK 		'A' is 40 mm high
			-- 	On Windows	'A' is 44 mm high
		once
			Result := 40 / 44
		end

end
