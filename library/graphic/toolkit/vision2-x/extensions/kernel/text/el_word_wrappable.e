note
	description: "Word wrappable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 13:35:13 GMT (Monday 17th October 2022)"
	revision: "11"

deferred class
	EL_WORD_WRAPPABLE

inherit
	EL_HYPENATEABLE

	EL_TEXT_ALIGNMENT

	EL_MODULE_TEXT

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	new_text_rectangle (a_text: READABLE_STRING_GENERAL): EL_TEXT_RECTANGLE
		require
			Text.is_word_wrappable (a_text, font, width)
		do
			create Result.make (0, 0, width, height)
			Result.set_font (font)
			Result.copy_alignment (Current)
			Result.append_line (a_text)
		end

	new_wrapped_text_rectangle (a_text: ZSTRING): EL_TEXT_RECTANGLE
		require
			Text.is_word_wrappable (a_text, font, width)
		do
			if is_aligned_top then
				create Result.make (0, 0, width, 100000)
			else
				create Result.make (0, 0, width, height)
			end
			if is_hyphenated then
				Result.enable_word_hyphenation
			end
			Result.set_font (font)
			Result.copy_alignment (Current)
			across a_text.lines as line loop
				Result.append_words (line.item)
			end
		end

	wrapped_lines (a_text: ZSTRING): EL_ZSTRING_LIST
		require
			Text.is_word_wrappable (a_text, font, width)
		do
			Result := new_wrapped_text_rectangle (a_text).lines
		end

	width: INTEGER
		deferred
		end

	height: INTEGER
		deferred
		end

	font: EV_FONT
		deferred
		end

end