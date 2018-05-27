note
	description: "Label pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_LABEL_PIXMAP

inherit
	EL_DRAWING_PIXMAP
		undefine
			redraw
		end

	EL_DRAWABLE_LABEL
		undefine
			default_create, copy, is_equal
		redefine
			redraw
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
end