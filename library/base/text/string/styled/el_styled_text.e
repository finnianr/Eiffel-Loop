note
	description: "String to be styled with a regular or bold font in a styleable component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 14:29:08 GMT (Wednesday 17th October 2018)"
	revision: "4"

class
	EL_STYLED_TEXT

inherit
	EL_STRING_8_CONSTANTS

	EL_SHARED_ONCE_STRINGS

create
	make

convert
	make ({STRING_32, STRING, ZSTRING, READABLE_STRING_GENERAL})

feature {NONE} -- Initialization

	make (a_text: like text)
		do
			text := a_text
		end

feature -- Access

	as_string_32: STRING_32
		do
			Result := text.as_string_32
		end

feature -- Status report

	is_bold: BOOLEAN

feature -- Element change

	set_bold
			--
		do
			is_bold := True
		end

	prepend_space
		local
			l_text: ZSTRING
		do
			create l_text.make (text.count + 1)
			l_text.append_character (' ')
			l_text.append_string_general (text)
			text := l_text
		end

	remove_last_word
		-- Remove last word from `text' and append an ellipsis ".."
		local
			space_pos: INTEGER
		do
			space_pos := text.last_index_of (' ', text.count)
			if space_pos > 0 then
				text := text.substring (1, space_pos) + Ellipsis_string_8
			end
		end

feature -- Measurement

	width (a_styleable: EL_MIXED_FONT_STYLEABLE_I): INTEGER
			-- width `text' for `a_styleable' component
		do
			Result := internal_width (a_styleable, text)
		end

	leading_spaces_width (a_styleable: EL_MIXED_FONT_STYLEABLE_I): INTEGER
			-- width of leading spaces in `text' for `a_styleable' component
		local
			i: INTEGER; spaces: like Once_string_32
		do
			spaces := empty_once_string_32
			from i := 1 until i > text.count or else text [i] /= ' ' loop
				spaces.append_character (' ')
				i := i + 1
			end
			Result := internal_width (a_styleable, spaces)
		end

feature -- Basic operations

	change_font (a_styleable: EL_MIXED_FONT_STYLEABLE_I)
			-- Call back to a styleable object
		do
			if is_bold then
				a_styleable.set_bold
			else
				a_styleable.set_regular
			end
		end

feature {NONE} -- Implementation

	internal_width (a_styleable: EL_MIXED_FONT_STYLEABLE_I; string: READABLE_STRING_GENERAL): INTEGER
		-- width of string in styleable object
		do
			if is_bold then
				Result := a_styleable.bold_width (string)
			else
				Result := a_styleable.regular_width (string)
			end
		end

feature {EL_STYLED_TEXT} -- Internal attributes

	text: READABLE_STRING_GENERAL

end
