note
	description: "Svg template button pixmap set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-18 17:43:07 GMT (Tuesday 18th August 2020)"
	revision: "7"

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

	set_pixmap (name: ZSTRING; a_svg_icon: like new_svg_image)
		do
			Precursor (name, a_svg_icon)
			a_svg_icon.update_png
		end

	new_svg_image (svg_path: EL_FILE_PATH; width_cms: REAL): EL_SVG_TEMPLATE_PIXMAP
		do
			create Result.make_with_width_cms (svg_path, width_cms, background_color)
		end

end
