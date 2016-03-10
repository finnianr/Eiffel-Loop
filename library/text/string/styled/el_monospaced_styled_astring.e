note
	description: "String to be styled with fixed width font in a styleable component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-26 14:59:35 GMT (Wednesday 26th March 2014)"
	revision: "5"

class
	EL_MONOSPACED_STYLED_ASTRING

inherit
	EL_STYLED_ASTRING
		redefine
			change_font, width
		end

create
	make_from_latin1, make_from_other, make_empty, make_filled, make

convert
	make_from_latin1 ({STRING}), make_from_other ({ASTRING})

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
