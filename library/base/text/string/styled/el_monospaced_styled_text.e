note
	description: "String to be styled with fixed width font in a styleable component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-09 18:42:57 GMT (Wednesday 9th August 2017)"
	revision: "3"

class
	EL_MONOSPACED_STYLED_TEXT

inherit
	EL_STYLED_TEXT
		redefine
			change_font, width
		end

create
	make

convert
	make ({STRING_32, STRING, ZSTRING})

feature -- Measurement

	width (a_styleable: EL_MIXED_FONT_STYLEABLE_I): INTEGER
		do
			if is_bold then
				Result := a_styleable.monospaced_bold_width (text.to_string_32)
			else
				Result := a_styleable.monospaced_width (text.to_string_32)
			end
		end

feature -- Basic operations

	change_font (a_styleable: EL_MIXED_FONT_STYLEABLE_I)
			-- Call back to a styleable object
		do
			if is_bold then
				a_styleable.set_monospaced_bold
			else
				a_styleable.set_monospaced
			end
		end

end
