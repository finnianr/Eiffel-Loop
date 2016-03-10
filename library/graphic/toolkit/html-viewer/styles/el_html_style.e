note
	description: "Summary description for {EL_HTML_PARAGRAPH_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-26 14:15:57 GMT (Sunday 26th May 2013)"
	revision: "2"

class
	EL_HTML_STYLE

inherit
	EL_MODULE_GUI

	EL_MODULE_SCREEN

create
	make

feature {NONE} -- Initialization

	make (a_font: like font; a_background_color: like background_color)
		local
			l_font: EL_FONT
		do
			font := a_font; background_color := a_background_color

			create heading_formats.make (1, Relative_header_sizes.count)

			create heading_fonts.make (1, heading_levels.count)
			across heading_levels as level loop
				l_font := regular_font
				l_font.set_height (heading_size (level.item))
				if level.item <= 4 then
					l_font.set_weight (GUI.Weight_bold)
				end
				if level.item = 6 then
					l_font.set_shape (GUI.Shape_italic)
				end
				heading_fonts [level.item] := l_font
			end

			across heading_fonts as h_font loop
				heading_formats [h_font.cursor_index] := [
					heading_paragraph_format (h_font.item), new_character_format (h_font.item)
				]
			end
			heading_formats.item (1).paragraph.enable_center_alignment

			normal_format := [Default_paragraph_format, new_character_format (regular_font)]

			preformatted_format := [Preformatted_paragraph_format, new_character_format (fixed_width_font)]
			preformatted_format.character.set_background_color (darkened_background_color)
		end

feature -- Access

	normal_format: TUPLE [paragraph: EL_PARAGRAPH_FORMAT; character: EV_CHARACTER_FORMAT]

	preformatted_format: like normal_format

	heading_formats: ARRAY [like normal_format]

	heading_fonts: ARRAY [EL_FONT]

feature -- Colors

	background_color: EV_COLOR

	darkened_background_color: EV_COLOR
		local
			red, green, blue: REAL
		do
			Result := background_color
			red := darken_color (Result.red)
			green := darken_color (Result.green)
			blue := darken_color (Result.blue)
			create Result.make_with_rgb (red, green, blue)
		end

feature -- Fonts

	font: EL_FONT

	regular_font: EL_FONT
		do
			Result := font.twin
		end

	fixed_width_font: EL_FONT
		do
			create Result
			across << "Fixedsys", "Monospace", "Courier New" >> as family loop
				Result.preferred_families.extend (family.item)
			end
			Result.set_family (GUI.Family_typewriter)
			Result.set_height (heading_size (6))
		end

	bold_font: EL_FONT
		do
			Result := regular_font
			Result.set_weight (GUI.Weight_bold)
		end

feature {NONE} -- Paragraph formats

	heading_paragraph_format (a_font: EL_FONT): EL_PARAGRAPH_FORMAT
			--
		do
			create Result
			Result.set_top_spacing ((a_font.line_height / 2).rounded)
			Result.set_bottom_spacing ((a_font.line_height / 4).rounded)
			Result.set_left_margin (Left_margin)
		end

	Default_paragraph_format: EL_PARAGRAPH_FORMAT
			--
		once
			create Result
			Result.set_left_margin (Left_margin)
		end

	Preformatted_paragraph_format: EL_PARAGRAPH_FORMAT
			--
		once
			create Result
			Result.set_left_margin (Left_margin)
		end

feature {NONE} -- Implementation

	new_character_format (a_font: EL_FONT): EV_CHARACTER_FORMAT
			--
		do
			create Result.make_with_font_and_color (a_font, GUI.Black, background_color)
		end

	darken_color (intensity: REAL): REAL
			--
		do
			Result := intensity * 0.8
		end

	heading_size (a_level: INTEGER): INTEGER
			--
		require
			valid_level: heading_levels.has (a_level)
		do
			Result := (regular_font.height * relative_header_sizes [a_level]).rounded
		end

feature -- Constants

	heading_levels: INTEGER_INTERVAL
		once
			Result := 1 |..| 6
		end

	Relative_header_sizes: ARRAY [REAL]
			--
		once
			Result := << 1.5, 1.25, 1.15, 1, 0.9, 0.8 >>
		end

	Left_margin: INTEGER
			--
		once
			Result := Screen.horizontal_pixels (0.35)
		end
end
