note
	description: "Label with background pixmap that can be used as a title-bar to drag a window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-05 19:03:35 GMT (Wednesday 5th July 2023)"
	revision: "12"

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

	use_as_drag_bar (window: EV_WINDOW)
		-- allow `Current' label to be used as a bar to drag `window'
		do
			create drag_bar.make (window, Current)
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Internal attributes

	implementation: EL_PIXMAP_I

	drag_bar: detachable EL_WINDOW_DRAG

end