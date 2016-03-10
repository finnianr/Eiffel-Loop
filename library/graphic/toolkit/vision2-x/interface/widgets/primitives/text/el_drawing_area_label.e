note
	description: "Summary description for {EL_DRAWING_AREA_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-02 13:01:01 GMT (Thursday 2nd April 2015)"
	revision: "6"

class
	EL_DRAWING_AREA_LABEL

inherit
	EL_DRAWING_AREA
		undefine
			on_redraw, on_resize
		end

	EL_DRAWABLE_LABEL
		undefine
			default_create, copy, is_equal
		redefine
			make_with_text_and_font
		end

create
	make_with_text_and_font, make_default

feature {NONE} -- Initialization

	make_with_text_and_font (a_text: like text; a_font: like font)
		do
			Precursor (a_text, a_font)
			set_expose_actions
			resize_actions.extend (agent on_resize)
		end

feature {NONE} -- Event handlers

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if a_height > 1 and a_width > 1 then
				redraw
			end
		end

end
