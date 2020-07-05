note
	description: "Cairo constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_CAIRO_CONSTANTS

feature {NONE} -- Image formats

	Cairo_format_INVALID: INTEGER = -1

	Cairo_format_ARGB_32: INTEGER = 0

	Cairo_format_RGB_24: INTEGER = 1

	Cairo_format_A8: INTEGER = 2

	Cairo_format_A1: INTEGER = 3

	Cairo_format_RGB16_565: INTEGER = 4

	Cairo_format_RGB30: INTEGER = 5

feature {NONE} -- Font shapes

	Cairo_font_slant_normal: INTEGER = 0

	Cairo_font_slant_italic: INTEGER = 1

	Cairo_font_slant_oblique: INTEGER = 2

feature {NONE} -- Font weights

	Cairo_font_weight_normal: INTEGER = 0

	Cairo_font_weight_bold: INTEGER = 1

feature {NONE} -- Antialias modes

	Cairo_antialias_default: INTEGER = 0

    -- method
	Cairo_antialias_none: INTEGER = 1

	Cairo_antialias_gray: INTEGER = 2

	Cairo_antialias_subpixel: INTEGER = 3

    -- hints
	Cairo_antialias_fast: INTEGER = 4

	Cairo_antialias_good: INTEGER = 5

	Cairo_antialias_best: INTEGER = 6

end
