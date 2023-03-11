note
	description: "Cairo constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:02:52 GMT (Friday 10th March 2023)"
	revision: "10"

class
	CAIRO_CONSTANTS

feature -- Contract support

	is_valid_filter (filter: INTEGER): BOOLEAN
		do
			inspect filter
				when Filter_fast .. Filter_gaussian then
					Result := True
			else
			end
		end

	is_valid_format (format: INTEGER): BOOLEAN
		do
			inspect format
				when Format_ARGB_32 .. Format_RGB30 then
					Result := True
			else
			end
		end

feature -- Filter type

	Filter_best: INTEGER = 2

	Filter_bilinear: INTEGER = 4

	Filter_fast: INTEGER = 0

	Filter_gaussian: INTEGER = 5

	Filter_good: INTEGER = 1

	Filter_nearest: INTEGER = 3

feature -- Image formats

	Format_A1: INTEGER = 3

	Format_A8: INTEGER = 2

	Format_ARGB_32: INTEGER = 0

	Format_INVALID: INTEGER = -1

	Format_RGB16_565: INTEGER = 4

	Format_RGB30: INTEGER = 5

	Format_RGB_24: INTEGER = 1

feature {NONE} -- Font shapes

	Font_slant_italic: INTEGER = 1

	Font_slant_normal: INTEGER = 0

	Font_slant_oblique: INTEGER = 2

feature -- Font weights

	Font_weight_bold: INTEGER = 1

	Font_weight_normal: INTEGER = 0

feature -- Antialias modes

	Antialias_default: INTEGER = 0

feature -- Antialias methods

	Antialias_gray: INTEGER = 2

	Antialias_none: INTEGER = 1

	Antialias_subpixel: INTEGER = 3

feature -- Antialias hints

	Antialias_best: INTEGER = 6

	Antialias_fast: INTEGER = 4

	Antialias_good: INTEGER = 5

end