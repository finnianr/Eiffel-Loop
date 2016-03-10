note
	description: "Summary description for {EL_TRANSPARENT_SVG_PIXMAP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-15 12:35:42 GMT (Wednesday 15th May 2013)"
	revision: "2"

class
	EL_TRANSPARENT_SVG_PIXMAP

inherit
	EL_SVG_PIXMAP
		rename
			make_with_width as make_with_width_and_color,
			make_with_height as make_with_height_and_color,
			make_with_width_cms as make_with_cms_width_and_color,
			make_with_height_cms as make_with_cms_height_and_color,
			make_with_path_and_width as make_with_svg_location_and_width_and_color,
			make_with_path_and_height as make_with_svg_location_and_height_and_color
		export
			{NONE} set_background_color
		redefine
			modifyable_colors
		end
create
	make_with_width, make_with_height, make_with_width_cms, make_with_height_cms,
	make_from_other,
	make_with_svg_location_and_width, make_with_svg_location_and_height

feature {NONE} -- Initialization

	make_with_width (a_svg_path: like svg_path; a_width: INTEGER)
			--
		do
			make_with_svg_location_and_width (a_svg_path, a_width)
		end

	make_with_height (a_svg_path: like svg_path; a_height: INTEGER)
			--
		do
			make_with_svg_location_and_height (a_svg_path, a_height)
		end

	make_with_width_cms (a_svg_path: like svg_path; a_width_cms: REAL)
			--
		do
			make_with_svg_location_and_width (a_svg_path, Screen.horizontal_pixels (a_width_cms))
		end

	make_with_height_cms (a_svg_path: like svg_path; a_height_cms: REAL)
			--
		do
			make_with_svg_location_and_height (a_svg_path, Screen.vertical_pixels (a_height_cms))
		end

	make_with_svg_location_and_width (
		a_svg_path: like svg_path; a_width: INTEGER
	)
			--
		do
			make_with_svg_location_and_width_and_color (a_svg_path, a_width, create {EV_COLOR})
			background_color_24_bit := SVG.Color_transparent
		end

	make_with_svg_location_and_height (
		a_svg_path: like svg_path; a_height: INTEGER
	)
			--
		do
			make_with_svg_location_and_height_and_color (a_svg_path, a_height, create {EV_COLOR})
			background_color_24_bit := SVG.Color_transparent
		end

feature {NONE} -- Implementation

	modifyable_colors: ARRAYED_LIST [INTEGER]
		do
			create Result.make (0)
		end

end
