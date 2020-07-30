note
	description: "Svg template button pixmap set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-09 10:35:20 GMT (Thursday 9th July 2020)"
	revision: "6"

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
			Result := pixmap_table [SVG.normal]
		end

feature {NONE} -- Implementation

	set_pixmap (name: ZSTRING; a_svg_icon: like normal)
		do
			Precursor (name, a_svg_icon)
			a_svg_icon.update_png
		end

end
