note
	description: "Summary description for {EL_PIXMAPABLE_LABEL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
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
