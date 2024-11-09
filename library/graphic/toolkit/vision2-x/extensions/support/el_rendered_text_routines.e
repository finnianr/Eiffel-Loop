note
	description: "[
		Vision 2 giving access to various shared objects and routines related to
		
		* Fonts and font string measurement
		* Word wrapping
		* Color code conversion
		* Action management
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 11:39:48 GMT (Friday 8th November 2024)"
	revision: "47"

class
	EL_RENDERED_TEXT_ROUTINES

inherit
	EV_SHARED_APPLICATION
		export
			{NONE} all
		end

	EV_FONT_CONSTANTS

	EL_SHARED_DEFAULT_PIXMAPS; EL_SHARED_STRING_32_BUFFER_POOL; EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			text_field_font := (create {EV_TEXT_FIELD}).font
			create internal_font
			internal_font.preferred_families.extend (Default_family)
			internal_font.preferred_families.start
		end

feature -- Family constants

	Font_families: EL_FONT_FAMILIES_I
		once
			create {EL_FONT_FAMILIES_IMP} Result
		end

	Pango_font_families: EL_FONT_FAMILIES_I
		-- fonts compatible with Cairo Pango font rendering API
		-- (on Windows many fonts cause Pango console warning: "couldn't load font .. ugly output")
		once
			create {EL_PANGO_FONT_FAMILIES_IMP} Result
		end

feature -- Font

	scale_font (font: EV_FONT; proportion: REAL)
		do
			font.set_height ((font.height * proportion).rounded.max (5))
		end

	text_field_font: EV_FONT

	word_wrapped (a_text: ZSTRING; a_font: EV_FONT; a_width: INTEGER): EL_ZSTRING_LIST
		-- string word wrapped with `a_font' across `a_width'
		require
			is_wrappable: is_word_wrappable (a_text, a_font, a_width)
		local
			words: EL_SPLIT_ZSTRING_LIST; line: ZSTRING
		do
			create Result.make (10)
			create line.make (60)
			create words.make (a_text, ' ')
			from words.start until words.after loop
				if not line.is_empty then
					line.append_character (' ')
				end
				line.append (words.item)
				if string_width (line, a_font) > a_width then
					line.remove_tail (words.item_count)
					line.right_adjust
					Result.extend (line.twin)
					line.wipe_out
				else
					words.forth
				end
			end
			if not line.is_empty then
				Result.extend (line)
			end
		end

feature -- Contract support

	is_word_wrappable (a_text: READABLE_STRING_GENERAL; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			if attached String_pool.sufficient_item (a_text.count) as borrowed then
				Result := across borrowed.to_same (a_text).split ('%N') as line all
					all_words_fit_width (line.item, a_font, a_width)
				end
				borrowed.return
			end
		end

	preferred_family_set: BOOLEAN
		do
			if attached internal_font.preferred_families as families then
				Result := families.count = 1 and not families.off
			end
		end

	same_fonts (a, b: EV_FONT): BOOLEAN
		do
			Result := a ~ b and then a.name ~ b.name
		end

feature -- Measurement

	string_width (string: READABLE_STRING_GENERAL; a_font: EV_FONT): INTEGER
		do
			if attached String_32_pool.borrowed_item as borrowed then
				Result := a_font.string_width (borrowed.to_same (string))
				borrowed.return
			end
		end

	widest_width (strings: ITERABLE [READABLE_STRING_GENERAL]; font: EV_FONT): INTEGER
			-- widest string width for font
		local
			width: INTEGER
		do
			across strings as list loop
				width := string_width (list.item, font)
				if width > Result then
					Result := width
				end
			end
		end

feature -- Basic operations

	set_clipboard (str: READABLE_STRING_GENERAL)
		do
			ev_application.clipboard.set_text (str.to_string_32)
		end

feature {EL_FONT_FAMILIES_I} -- Implementation

	all_words_fit_width (line: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := across line.split (' ') as word all word_fits_width (word.item, a_font, a_width) end
		end

	is_monospace (font_family: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := not is_proportional (font_family)
		end

	is_proportional (font_family: READABLE_STRING_GENERAL): BOOLEAN
		require
			preferred_family_set: preferred_family_set
		do
			if attached internal_font as l_font then
				l_font.preferred_families.replace (font_family.to_string_32)
				Result := l_font.is_proportional
			end
		end

	word_fits_width (word: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := string_width (word, a_font) < a_width
		end

feature {NONE} -- Internal attributes

	internal_font: EL_FONT

feature {NONE} -- Constants

	Default_family: STRING = "Serif"
end