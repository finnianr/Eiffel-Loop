note
	description: "String to be styled with fixed width font in a styleable component"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
	make_from_latin1 ({STRING}), make_from_other ({EL_ASTRING})

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
