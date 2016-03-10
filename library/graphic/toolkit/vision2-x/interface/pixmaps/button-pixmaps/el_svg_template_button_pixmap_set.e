note
	description: "Summary description for {EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET

inherit
	EL_SVG_BUTTON_PIXMAP_SET
		redefine
			normal, set_pixmap
		end

create
	make

feature -- Access

	normal: EL_SVG_TEMPLATE_PIXMAP
		do
			Result := pixmaps [Normal_svg]
		end

feature {NONE} -- Implementation

	set_pixmap (name: ASTRING; a_svg_icon: like normal)
		do
			Precursor (name, a_svg_icon)
			a_svg_icon.update_png
		end

end
