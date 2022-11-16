note
	description: "Pango cairo constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	CAIRO_PANGO_CONSTANTS

feature -- Font styles

	Style_italic: INTEGER = 0
		-- the font is slanted in an italic style.

	Style_normal: INTEGER = 0
		-- the font is upright.

	Style_oblique: INTEGER = 0
		-- the font is slanted, but in a roman style.

feature -- Font weights

	Weight_bold: INTEGER = 700

	Weight_book: INTEGER = 380

	Weight_heavy: INTEGER = 900

	Weight_light: INTEGER = 300

	Weight_medium: INTEGER = 500

	Weight_normal: INTEGER = 400

	Weight_semibold: INTEGER = 600

	Weight_thin: INTEGER = 100

	Weight_ultrabold: INTEGER = 800

	Weight_ultraheavy: INTEGER = 1000

	Weight_ultralight: INTEGER = 200

feature -- Font horizontal stretch

	Stretch_condensed: INTEGER = 2
		-- condensed width

	Stretch_expanded: INTEGER = 6
		-- expanded width

	Stretch_extra_condensed: INTEGER = 1
		-- extra condensed width

	Stretch_extra_expanded: INTEGER = 7
		-- extra expanded width

	Stretch_normal: INTEGER = 4
		-- the normal width

	Stretch_semi_condensed: INTEGER = 3
		-- semi condensed width

	Stretch_semi_expanded: INTEGER = 5
		-- semi expanded width

	Stretch_ultra_condensed: INTEGER = 0
		-- ultra condensed width

	Stretch_ultra_expanded: INTEGER = 8
		-- ultra expanded width

feature -- Contract Support

	is_valid_stretch (value: INTEGER): BOOLEAN
		do
			inspect value
				when Stretch_ultra_condensed .. Stretch_ultra_expanded then
					Result := True
			else
			end
		end

end