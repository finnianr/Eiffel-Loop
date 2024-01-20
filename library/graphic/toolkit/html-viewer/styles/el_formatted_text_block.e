note
	description: "[
		List of formatted paragraph texts of type ${ZSTRING} with format
		of type ${EV_CHARACTER_FORMAT}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "13"

class
	EL_FORMATTED_TEXT_BLOCK

inherit
	EL_ARRAYED_MAP_LIST [ZSTRING, EV_CHARACTER_FORMAT]
		rename
			first_key as first_text,
			item_key as item_text,
			item_value as item_format,
			make as make_sized,
			last_key as last_text,
			replace_key as replace_text
		export
			{NONE} all
			{ANY} first_text, start, after, forth, item_text, item_format
		end

	EL_MODULE_COLOR; EL_MODULE_VISION_2

	EL_MODULE_TEXT
		rename
			Text as Rendered
		end

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_styles: like styles; a_block_indent: INTEGER)
		do
			styles := a_styles; block_indent := a_block_indent
			make_sized (4)
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
			create Result.make (offset + 1, offset + character_count)
		end

	block_indent: INTEGER

	format: like styles.normal_format

	styles: EL_TEXT_FORMATTING_STYLES

	text_style: EV_CHARACTER_FORMAT
		do
			Result := format.character
		end

feature -- Measurement

	character_count: INTEGER

	offset: INTEGER

feature -- Fonts

	font: EV_FONT

	italic_font: EV_FONT
		do
			Result := font.twin
			Result.set_shape (Rendered.Shape_italic)
		end

	bold_font: EV_FONT
		do
			Result := font.twin
			Result.set_weight (Rendered.Weight_bold)
		end

feature -- Element change

	append_text (a_text: ZSTRING)
		local
			text: ZSTRING
		do
			if a_text.ends_with_character ('%N') then
				text := a_text
			else
				text := a_text + space
			end
			extend (text, format.character)
			character_count := character_count + text.count
		end

	append_new_line
		do
			if count > 0 and then last_text = new_line.to_string then
				finish
				replace_text (new_line * 2)
			else
				extend (New_line, New_line_format)
			end
			character_count := character_count + 1
		end

	set_offset (a_offset: like offset)
		do
			offset := a_offset
		end

feature -- Status query

	is_text_empty: BOOLEAN
		do
			Result := character_count = 0
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
			change_text_style (agent text_style.set_color (Color.Blue))
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
			change_text_style (agent text_style.set_color (Color.Black))
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

	change_text_style (change: PROCEDURE)
		require
			valid_change: attached {EV_CHARACTER_FORMAT} change.target
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

	New_line_format: EV_CHARACTER_FORMAT
		do
			create Result.make_with_font (Vision_2.new_font_regular ("Arial", Line_separation_cms))
		end

	Line_separation_cms: REAL
		once
			Result := 0.1
		end

end