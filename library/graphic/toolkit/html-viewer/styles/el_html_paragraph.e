note
	description: "Summary description for {EL_HTML_PARAGRAPH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:21:38 GMT (Wednesday 24th July 2013)"
	revision: "3"

class
	EL_HTML_PARAGRAPH

inherit
	EL_MODULE_STRING

	EL_MODULE_GUI

	EL_MODULE_TYPING

create
	make

feature {NONE} -- Initialization

	make (a_style: like style; a_block_indent: INTEGER)
		do
			style := a_style; block_indent := a_block_indent
			create character_formats.make (4)
			create text.make_empty
			set_format
			font := format.character.font
			if block_indent > 0 then
				format.paragraph := format.paragraph.twin
				format.paragraph.set_left_margin (style.Left_margin * (block_indent + 1))
			end
		end

feature -- Access

	text: EL_ASTRING

	lower_pos: INTEGER

	upper_pos: INTEGER
		-- page substring

	block_indent: INTEGER

	format: like style.normal_format

	style: EL_HTML_STYLE

	character_formats: ARRAYED_LIST [TUPLE [format: EV_CHARACTER_FORMAT; lower_pos, upper_pos: INTEGER]]
		-- applied character formats

	text_style: EV_CHARACTER_FORMAT
		do
			Result := format.character
		end

feature -- Fonts

	font: EV_FONT

	italic_font: EV_FONT
		do
			Result := font.twin
			Result.set_shape (GUI.Shape_italic)
		end

feature -- Element change

	append_text (a_text: like text)
		local
			l_character_format: like character_formats.item
		do
			create l_character_format
			if text.is_empty then
				text.append (a_text)
				l_character_format.lower_pos := 1
			else
				if text.item (text.count) /= '%N' then
					text.append_character (' ')
					l_character_format.lower_pos := text.count
				else
					l_character_format.lower_pos := text.count + 1
				end
				text.append (a_text)
			end
			l_character_format.upper_pos := text.count
			l_character_format.format := format.character
			character_formats.extend (l_character_format)
		end

	append_new_line
		do
			if character_formats.is_empty then
				append_text (once "%N")
			else
				text.append_character ('%N')
				character_formats.last.upper_pos := text.count
			end
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := text.count = 1 and text.item_code (1) = {ASCII}.blank
		end

feature -- Basic operations

	separate_from_previous (a_previous: EL_HTML_PARAGRAPH)
			-- append new line to previous paragraph if not a header
		local
			previous_type: TYPE [ANY]
		do
			previous_type := Typing.type_of (a_previous)
			if previous_type /~ {EL_HTML_HEADER} or previous_type ~ {EL_HTML_NUMBERED_PARAGRAPH} then
				a_previous.append_new_line
			end
		end

	attach_to_rich_text (a_rich_text: EV_RICH_TEXT; a_total_count: INTEGER_REF)
		local
			substring: EL_ASTRING
		do
			append_new_line
			lower_pos := a_total_count + 1
			across character_formats as l_format loop
				substring := text.substring (l_format.item.lower_pos, l_format.item.upper_pos)
				a_rich_text.buffered_append (substring.to_unicode, l_format.item.format)
				a_total_count.set_item (a_total_count.item + substring.count)
			end
			upper_pos := a_total_count
		end

feature -- Status setting

	enable_italic
		do
			change_text_style (agent text_style.set_font (italic_font))
		end

	disable_italic
		do
			change_text_style (agent text_style.set_font (font))
		end

	enable_fixed_width
		do
			change_text_style (agent text_style.set_font (style.fixed_width_font))
		end

	disable_fixed_width
		do
			change_text_style (agent text_style.set_font (font))
		end

	enable_darkend_fixed_width
		do
			enable_fixed_width
			change_text_style (agent text_style.set_background_color (style.darkened_background_color))
		end

	disable_darkend_fixed_width
		do
			disable_fixed_width
			change_text_style (agent text_style.set_background_color (style.background_color))
		end

	enable_blue
		do
			change_text_style (agent text_style.set_color (GUI.Blue))
		end

	disable_blue
		do
			change_text_style (agent text_style.set_color (GUI.Black))
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
			format := style.normal_format.twin
		end

	cached_character_format (a_format: EV_CHARACTER_FORMAT): EV_CHARACTER_FORMAT
		do
			character_format_cache.search (a_format.out)
			if character_format_cache.found then
				Result := character_format_cache.found_item
			else
				Result := a_format
				character_format_cache.extend (a_format, a_format.out)
			end
		end

	Character_format_cache: EL_ASTRING_HASH_TABLE [EV_CHARACTER_FORMAT]
		once
			create Result.make_with_count (7)
			Result.compare_objects
		end

end
