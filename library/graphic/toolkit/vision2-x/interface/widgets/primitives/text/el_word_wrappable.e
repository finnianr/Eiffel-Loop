note
	description: "Summary description for {EL_WORD_WRAPPABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	EL_WORD_WRAPPABLE

inherit
	EL_HYPENATEABLE

	EL_TEXT_ALIGNMENT

	EL_MODULE_GUI

feature {NONE} -- Implementation

	wrapped_lines (a_text: ASTRING): EL_ASTRING_LIST
		require
			GUI.is_word_wrappable (a_text, font, width)
		do
			Result := wrapped_text_rectangle (a_text).lines
		end

	wrapped_text_rectangle (a_text: ASTRING): EL_TEXT_RECTANGLE
		require
			GUI.is_word_wrappable (a_text, font, width)
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
			Result.append_words (a_text)
		end

	text_rectangle (a_text: ASTRING): EL_TEXT_RECTANGLE
		require
			GUI.is_word_wrappable (a_text, font, width)
		do
			create Result.make (0, 0, width, height)
			Result.set_font (font)
			Result.copy_alignment (Current)
			Result.append_line (a_text)
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
