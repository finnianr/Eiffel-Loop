note
	description: "Label pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 13:42:14 GMT (Monday 17th October 2022)"
	revision: "10"

class
	EL_LABEL_PIXMAP

inherit
	EL_DRAWING_PIXMAP
		redefine
			redraw, implementation
		end

	EL_DRAWABLE_LABEL
		undefine
			copy, initialize, is_equal, is_in_default_state, sub_pixmap
		redefine
			implementation
		end

create
	make_with_text_and_font

feature -- Basic operations

	redraw
		do
			if width > 1 and height > 1 then
				Precursor
			end
		end

feature -- Status change

	set_width_for_border (border_cms: REAL)
		do
			set_minimum_width (Rendered.string_width (text, font) + Screen.horizontal_pixels (border_cms))
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	implementation: EL_PIXMAP_I

end