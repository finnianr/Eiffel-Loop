note
	description: "Summary description for {EL_HTML_PARAGRAPH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 7:35:27 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_FORMATTED_TEXT_BLOCK

inherit
	EL_MODULE_GUI

	EL_MODULE_VISION_2

create
	make

feature {NONE} -- Initialization

	make (a_styles: like styles; a_block_indent: INTEGER)
		do
			styles := a_styles; block_indent := a_block_indent
			create paragraphs.make (4)
			set_format
			font := format.character.font
			if block_indent > 0 then
				format.paragraph := format.paragraph.twin
				format.paragraph.set_left_margin (styles.Left_margin * (block_indent + 1))
			end
		end

feature -- Access

	interval: INTEGER_INTERVAL
		-- page text substring interval
		do
			create Result.make (offset + 1, offset + count)
		end

	block_indent: INTEGER

	format: like styles.normal_format

	styles: EL_TEXT_FORMATTING_STYLES

	paragraphs: ARRAYED_LIST [TUPLE [text: ZSTRING; format: EV_CHARACTER_FORMAT]]
		-- paragraph with applied character formatting

	text_style: EV_CHARACTER_FORMAT
		do
			Result := format.character
		end

feature -- Measurement

	count: INTEGER

	offset: INTEGER

feature -- Fonts

	font: EV_FONT

	italic_font: EV_FONT
		do
			Result := font.twin
			Result.set_shape (GUI.Shape_italic)
		end

	bold_font: EV_FONT
		do
			Result := font.twin
			Result.set_weight (GUI.Weight_bold)
		end

feature -- Element change

	append_text (a_text: ZSTRING)
		local
			text: ZSTRING
		do
			text := a_text
			if text.item (text.count) /= '%N' then
				text := a_text.twin
				text.append_character (' ')
			end
			paragraphs.extend ([text, format.character])
			count := count + text.count
		end

	append_new_line
		do
			if not paragraphs.is_empty and then paragraphs.last.text = New_line then
				paragraphs.last.text := Double_new_line
			else
				paragraphs.extend ([New_line, New_line_format])
			end
			count := count + 1
		end

	set_offset (a_offset: like offset)
		do
			offset := a_offset
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

feature -- Basic operations

	separate_from_previous (a_previous: EL_FORMATTED_TEXT_BLOCK)
			--
		do
			a_previous.append_new_line
			if not attached {EL_FORMATTED_TEXT_HEADER} a_previous
				or else attached {EL_FORMATTED_NUMBERED_PARAGRAPHS} a_previous
			then
				a_previous.append_new_line
			end
		end

feature -- Enable styles

	enable_bold
		do
			change_text_style (agent text_style.set_font (bold_font))
		end

	enable_blue
		do
			change_text_style (agent text_style.set_color (GUI.Blue))
		end

	enable_darkend_fixed_width
		do
			enable_fixed_width
			change_text_style (agent text_style.set_background_color (styles.darkened_background_color))
		end

	enable_fixed_width
		do
			change_text_style (agent text_style.set_font (styles.fixed_width_font))
		end

	enable_italic
		do
			change_text_style (agent text_style.set_font (italic_font))
		end

feature -- Disable styles

	disable_blue
		do
			change_text_style (agent text_style.set_color (GUI.Black))
		end

	disable_bold, disable_fixed_width, disable_italic
		do
			change_text_style (agent text_style.set_font (font))
		end

	disable_darkend_fixed_width
		do
			disable_fixed_width
			change_text_style (agent text_style.set_background_color (styles.background_color))
		end

feature {NONE} -- Implementation

	change_text_style (change: PROCEDURE [EV_CHARACTER_FORMAT, TUPLE])
		do
			change.set_target (change.target.twin)
			change.apply
			check attached {EV_CHARACTER_FORMAT} change.target as l_format then
				format.character := cached_character_format (l_format)
			end
		end

	set_format
		do
			format := styles.normal_format.twin
		end

	cached_character_format (a_format: EV_CHARACTER_FORMAT): EV_CHARACTER_FORMAT
		do
			character_format_cache.put (a_format, a_format.out)
			Result := character_format_cache.found_item
		end

	Character_format_cache: EL_ZSTRING_HASH_TABLE [EV_CHARACTER_FORMAT]
		once
			create Result.make_equal (7)
		end

feature {NONE} -- Constants

	New_line: ZSTRING
		once
			create Result.make_filled ('%N', 1)
		end

	Double_new_line: ZSTRING
		once
			create Result.make_filled ('%N', 2)
		end

	New_line_format: EV_CHARACTER_FORMAT
		do
			create Result.make_with_font (Vision_2.new_font_regular ("Arial", Line_separation_cms))
		end

	Line_separation_cms: REAL
		once
			Result := 0.1
		end

end