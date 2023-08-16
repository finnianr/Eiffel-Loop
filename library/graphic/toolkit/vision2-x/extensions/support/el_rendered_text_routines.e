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
	date: "2023-08-02 6:00:04 GMT (Wednesday 2nd August 2023)"
	revision: "41"

class
	EL_RENDERED_TEXT_ROUTINES

inherit
	EV_SHARED_APPLICATION
		export
			{NONE} all
		end

	EV_FONT_CONSTANTS

	EL_MODULE_REUSEABLE

	EL_SHARED_DEFAULT_PIXMAPS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			text_field_font := (create {EV_TEXT_FIELD}).font
			create internal_font
			letter := ["i", "w"]
		end

feature -- Font

	Font_families: EL_FONT_FAMILIES_I
		once
			create {EL_FONT_FAMILIES_IMP} Result
		end

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
			across Reuseable.string as reuse loop
				Result := across reuse.same_item (a_text).split ('%N') as line all
					all_words_fit_width (line.item, a_font, a_width)
				end
			end
		end

	same_fonts (a, b: EV_FONT): BOOLEAN
		do
			Result := a ~ b and then a.name ~ b.name
		end

feature -- Measurement

	string_width (string: READABLE_STRING_GENERAL; a_font: EV_FONT): INTEGER
		do
			across Reuseable.string_32 as reuse loop
				Result := a_font.string_width (reuse.same_item (string))
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

feature {EL_FONT_FAMILIES_I} -- Implementation

	all_words_fit_width (line: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := across line.split (' ') as word all word_fits_width (word.item, a_font, a_width) end
		end

	is_monospace (font_family: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached internal_font as l_font then
				l_font.preferred_families.wipe_out
				l_font.preferred_families.extend (font_family.to_string_32)
				Result := l_font.string_width (letter.narrow) = l_font.string_width (letter.wide)
			end
		end

	new_zstring (str: STRING_32): ZSTRING
		do
			Result := str
		end

	word_fits_width (word: ZSTRING; a_font: EV_FONT; a_width: INTEGER): BOOLEAN
		do
			Result := string_width (word, a_font) < a_width
		end

feature {NONE} -- Internal attributes

	internal_font: EV_FONT

	letter: TUPLE [narrow, wide: STRING]

end