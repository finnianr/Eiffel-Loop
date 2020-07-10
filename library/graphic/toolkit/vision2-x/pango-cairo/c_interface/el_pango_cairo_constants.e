note
	description: "Pango cairo constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-05 9:42:40 GMT (Sunday 5th July 2020)"
	revision: "6"

class
	EL_PANGO_CAIRO_CONSTANTS

feature -- Font styles

	Pango_style_normal: INTEGER = 0
		-- the font is upright.

	Pango_style_oblique: INTEGER = 0
		-- the font is slanted, but in a roman style.

	Pango_style_italic: INTEGER = 0
		-- the font is slanted in an italic style.

feature -- Font weights

	Pango_weight_thin: INTEGER = 100

	Pango_weight_ultralight: INTEGER = 200

	Pango_weight_light: INTEGER = 300

	Pango_weight_book: INTEGER = 380

	Pango_weight_normal: INTEGER = 400

	Pango_weight_medium: INTEGER = 500

	Pango_weight_semibold: INTEGER = 600

	Pango_weight_bold: INTEGER = 700

	Pango_weight_ultrabold: INTEGER = 800

	Pango_weight_heavy: INTEGER = 900

	Pango_weight_ultraheavy: INTEGER = 1000

feature -- Font horizontal stretch

	Pango_stretch_ultra_condensed: INTEGER = 0
		-- ultra condensed width

	Pango_stretch_extra_condensed: INTEGER = 1
		-- extra condensed width

	Pango_stretch_condensed: INTEGER = 2
		-- condensed width

	Pango_stretch_semi_condensed: INTEGER = 3
		-- semi condensed width

	Pango_stretch_normal: INTEGER = 4
		-- the normal width

	Pango_stretch_semi_expanded: INTEGER = 5
		-- semi expanded width

	Pango_stretch_expanded: INTEGER = 6
		-- expanded width

	Pango_stretch_extra_expanded: INTEGER = 7
		-- extra expanded width

	Pango_stretch_ultra_expanded: INTEGER = 8
		-- ultra expanded width

	Pango_stretch_values: ARRAYED_LIST [INTEGER]
		once
			create Result.make (9)
			across 0 |..| 8 as value loop
				Result.extend (value.item)
			end
		end

end
