note
	description: "Windows implementation of [$source EL_STOCK_COLORS_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-11 13:06:16 GMT (Friday 11th September 2020)"
	revision: "4"

class
	EL_STOCK_COLORS_IMP

inherit
	EL_STOCK_COLORS_I

	EL_OS_IMPLEMENTATION

feature -- Access

	Text_field_background: EV_COLOR
			--
		local
			system_colors: WEL_SYSTEM_COLORS; color_window: WEL_COLOR_REF
		once
			create system_colors
			color_window := system_colors.system_color_window
			create Result.make_with_8_bit_rgb (color_window.red, color_window.green, color_window.blue)
		end
end
