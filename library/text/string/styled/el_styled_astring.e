note
	description: "String to be styled with a regular or bold font in a styleable component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-26 15:00:34 GMT (Wednesday 26th March 2014)"
	revision: "4"

class
	EL_STYLED_ASTRING

inherit
	ASTRING
		redefine
			copy
		end

create
	make_from_latin1, make_from_other, make_empty, make_filled, make

convert
	make_from_latin1 ({STRING}), make_from_other ({ASTRING})

feature -- Status report

	is_bold: BOOLEAN

feature -- Element change

	set_bold
			--
		do
			is_bold := True
		end

	set_from_other (a_string: EL_STYLED_ASTRING)
		do
			wipe_out
			append (a_string)
			is_bold := a_string.is_bold
		end

feature -- Measurement

	width (a_styleable: EL_MIXED_FONT_STYLEABLE_I): INTEGER
		-- width of string in styleable object
		do
			if is_bold then
				Result := a_styleable.bold_width (to_unicode)
			else
				Result := a_styleable.regular_width (to_unicode)
			end
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

feature -- Duplication

	copy (other: like Current)
		do
			if other /= Current then
				Precursor {ASTRING} (other)
				is_bold := other.is_bold
			end
		end

end
