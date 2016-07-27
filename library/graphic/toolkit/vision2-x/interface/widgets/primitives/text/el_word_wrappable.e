note
	description: "Summary description for {EL_WORD_WRAPPABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:12:10 GMT (Friday 24th June 2016)"
	revision: "5"

deferred class
	EL_WORD_WRAPPABLE

inherit
	EL_HYPENATEABLE

	EL_TEXT_ALIGNMENT

	EL_MODULE_GUI

feature {NONE} -- Implementation

	new_text_rectangle (a_text: ZSTRING): EL_TEXT_RECTANGLE_I
		require
			GUI.is_word_wrappable (a_text, font, width)
		do
			create {EL_TEXT_RECTANGLE_IMP} Result.make (0, 0, width, height)
			Result.set_font (font)
			Result.copy_alignment (Current)
			Result.append_line (a_text)
		end

	new_wrapped_text_rectangle (a_text: ZSTRING): EL_TEXT_RECTANGLE_I
		require
			GUI.is_word_wrappable (a_text, font, width)
		do
			if is_aligned_top then
				create {EL_TEXT_RECTANGLE_IMP} Result.make (0, 0, width, 100000)
			else
				create {EL_TEXT_RECTANGLE_IMP} Result.make (0, 0, width, height)
			end
			if is_hyphenated then
				Result.enable_word_hyphenation
			end
			Result.set_font (font)
			Result.copy_alignment (Current)
			Result.append_words (a_text)
		end

	wrapped_lines (a_text: ZSTRING): EL_ZSTRING_LIST
		require
			GUI.is_word_wrappable (a_text, font, width)
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