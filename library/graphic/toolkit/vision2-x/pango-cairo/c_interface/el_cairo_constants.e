note
	description: "Cairo constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 12:55:13 GMT (Tuesday 28th July 2020)"
	revision: "7"

class
	EL_CAIRO_CONSTANTS

feature -- Contract support

	is_valid_format (format: INTEGER): BOOLEAN
		do
			inspect format
				when Format_ARGB_32 .. Format_RGB30 then
					Result := True
			else
			end
		end

	is_valid_filter (filter: INTEGER): BOOLEAN
		do
			inspect filter
				when Filter_fast .. Filter_gaussian then
					Result := True
			else
			end
		end

feature -- Filter type

    Filter_fast: INTEGER = 0

    Filter_good: INTEGER = 1

    Filter_best: INTEGER = 2

    Filter_nearest: INTEGER = 3

    Filter_bilinear: INTEGER = 4

    Filter_gaussian: INTEGER = 5

feature -- Image formats

	Format_INVALID: INTEGER = -1

	Format_ARGB_32: INTEGER = 0

	Format_RGB_24: INTEGER = 1

	Format_A8: INTEGER = 2

	Format_A1: INTEGER = 3

	Format_RGB16_565: INTEGER = 4

	Format_RGB30: INTEGER = 5

feature {NONE} -- Font shapes

	Font_slant_normal: INTEGER = 0

	Font_slant_italic: INTEGER = 1

	Font_slant_oblique: INTEGER = 2

feature -- Font weights

	Font_weight_normal: INTEGER = 0

	Font_weight_bold: INTEGER = 1

feature -- Antialias modes

	Antialias_default: INTEGER = 0

    -- method
	Antialias_none: INTEGER = 1

	Antialias_gray: INTEGER = 2

	Antialias_subpixel: INTEGER = 3

    -- hints
	Antialias_fast: INTEGER = 4

	Antialias_good: INTEGER = 5

	Antialias_best: INTEGER = 6

end
