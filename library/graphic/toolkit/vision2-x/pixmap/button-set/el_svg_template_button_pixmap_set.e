note
	description: "Svg template button pixmap set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-19 12:56:47 GMT (Wednesday 19th August 2020)"
	revision: "8"

class
	EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET

inherit
	EL_SVG_BUTTON_PIXMAP_SET
		redefine
			new_svg_image, set_pixmap
		end

create
	make

feature {NONE} -- Implementation

	set_pixmap (state: NATURAL_8; a_svg_icon: like new_svg_image)
		do
			Precursor (state, a_svg_icon)
			a_svg_icon.update_png
		end

	new_svg_image (svg_path: EL_FILE_PATH; width_cms: REAL): EL_SVG_TEMPLATE_PIXMAP
		do
			create Result.make_with_width_cms (svg_path, width_cms, background_color)
		end

end
