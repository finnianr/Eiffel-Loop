note
	description: "[
		Buttons with images for 3 states stored in application icons location
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:07:58 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_SVG_BUTTON_PIXMAP_SET

inherit
	EL_MODULE_ICON
		redefine
			default_create
		end

	EL_MODULE_STRING
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

	EL_MODULE_SCREEN
		undefine
			default_create
		end

	EL_MODULE_IMAGE_PATH
		undefine
			default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	default_create
		do
			create pixmaps.make_equal (3)
			create background_color
			create icon_path_steps
		end

	make (a_icon_path_steps: like icon_path_steps; width_cms: REAL; a_background_color: EL_COLOR)
			--
		do
			default_create
			icon_path_steps.grow (a_icon_path_steps.count + 1)
			icon_path_steps.append (a_icon_path_steps)
			background_color := a_background_color

			fill_pixmaps (width_cms)
		end

feature -- Access

	normal: EL_SVG_PIXMAP
		do
			Result := pixmap (Normal_svg)
		end

	highlighted: like normal
		do
			Result := pixmap (Highlighted_svg)
		end

	depressed: like normal
		do
			Result := pixmap (depressed_svg)
		end

	background_color: EL_COLOR

feature -- Element change

	set_background_color (a_background_color: like background_color)
		do
			if background_color /~ a_background_color then
				normal.set_background_color (a_background_color)
				highlighted.set_background_color (a_background_color)
				depressed.set_background_color (a_background_color)
			end
			background_color := a_background_color
		end

feature {NONE} -- Implementation

	fill_pixmaps (width_cms: REAL)
		do
			across << Normal_svg, Highlighted_svg, depressed_svg >> as svg_file loop
				pixmaps [svg_file.item] := svg_icon (svg_file.item, width_cms)
			end
		end

	svg_icon (last_step: EL_ASTRING; width_cms: REAL): like normal
		do
			icon_path_steps.extend (last_step)
			Result := Icon.svg_of_width_cms (icon_path_steps, width_cms, background_color)
			icon_path_steps.remove_tail (1)
		end

	pixmap (a_name: EL_ASTRING): like normal
		do
			pixmaps.search (a_name)
			if pixmaps.found then
				Result := pixmaps.found_item
			else
				create Result
			end
		end

	icon_path_steps: EL_PATH_STEPS

feature {NONE} -- Constants

	Highlighted_svg: EL_ASTRING
		once
			Result := "highlighted.svg"
		end

	depressed_svg: EL_ASTRING
		once
			Result := "depressed.svg"
		end

	Normal_svg: EL_ASTRING
		once
			Result := "normal.svg"
		end

	pixmaps: EL_ASTRING_HASH_TABLE [like normal]

	Highlighted_stop_color: STRING = "f9ffff"

	Clicked_border_width: CHARACTER = '6'

	Clicked_border_color: STRING = "efebe3"
end
