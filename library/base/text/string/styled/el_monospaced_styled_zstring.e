note
	description: "String to be styled with fixed width font in a styleable component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:20:59 GMT (Wednesday 16th December 2015)"
	revision: "7"

class
	EL_MONOSPACED_STYLED_ZSTRING

inherit
	EL_STYLED_ZSTRING
		redefine
			change_font, width
		end

create
	make_from_latin_1, make_from_other, make_empty, make_filled, make

convert
	make_from_latin_1 ({STRING}), make_from_other ({ZSTRING})

feature -- Measurement

	width (a_styleable: EL_MIXED_FONT_STYLEABLE_I): INTEGER
		do
			if is_bold then
				Result := a_styleable.monospaced_bold_width (to_unicode)
			else
				Result := a_styleable.monospaced_width (to_unicode)
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