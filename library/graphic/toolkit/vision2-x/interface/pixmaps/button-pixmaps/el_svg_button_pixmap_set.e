note
	description: "[
		Buttons with images for 3 states stored in application icons location
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-14 11:05:22 GMT (Thursday 14th January 2016)"
	revision: "7"

class
	EL_SVG_BUTTON_PIXMAP_SET

inherit
	EL_MODULE_ICON

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_SCREEN

	EL_MODULE_IMAGE_PATH

create
	make_default, make, make_transparent

feature {NONE} -- Initialization

	make_default
		do
			create pixmaps.make_equal (3)
			create background_color
			create icon_path_steps
			is_enabled := True
		end

	make_transparent (a_icon_path_steps: like icon_path_steps; width_cms: REAL)
		do
			make (a_icon_path_steps, width_cms, Icon.Transparent_color)
		end

	make (a_icon_path_steps: like icon_path_steps; width_cms: REAL; a_background_color: EL_COLOR)
			--
		do
			make_default
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

feature -- Status query

	is_enabled: BOOLEAN
		-- True if button is sensitive (enabled)

feature -- Element change

	set_background_color (a_background_color: like background_color)
		do
			if background_color /~ a_background_color then
				across pixmaps as l_pixmap loop
					l_pixmap.item.set_background_color (a_background_color)
				end
			end
			background_color := a_background_color
		end

feature -- Status setting

	set_enabled
		do
			is_enabled := True
		end

	set_disabled
		do
			is_enabled := False
		end

feature {NONE} -- Implementation

	fill_pixmaps (width_cms: REAL)
		local

		do
			across << Normal_svg, Highlighted_svg, depressed_svg >> as svg_file loop
				set_pixmap (svg_file.item, svg_icon (svg_file.item, width_cms))
			end
		end

	svg_icon (last_step: ZSTRING; width_cms: REAL): like normal
		do
			icon_path_steps.extend (last_step)
			Result := new_svg_image (Image_path.icon (icon_path_steps), width_cms)
			icon_path_steps.remove_tail (1)
		end

	new_svg_image (svg_path: EL_FILE_PATH; width_cms: REAL): like normal
		do
			create Result.make_with_width_cms (svg_path, width_cms, background_color)
		end

	pixmap (a_name: ZSTRING): like normal
		do
			pixmaps.search (a_name)
			if pixmaps.found then
				Result := pixmaps.found_item
			else
				create Result
			end
		end

	set_pixmap (name: ZSTRING; a_svg_icon: like normal)
		do
			pixmaps [name] := a_svg_icon
		end

	icon_path_steps: EL_PATH_STEPS

feature {NONE} -- Constants

	Highlighted_svg: ZSTRING
		once
			Result := "highlighted.svg"
		end

	Depressed_svg: ZSTRING
		once
			Result := "depressed.svg"
		end

	Normal_svg: ZSTRING
		once
			Result := "normal.svg"
		end

	pixmaps: EL_ZSTRING_HASH_TABLE [like normal]

	Highlighted_stop_color: STRING = "f9ffff"

	Clicked_border_width: CHARACTER = '6'

	Clicked_border_color: STRING = "efebe3"
end
