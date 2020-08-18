note
	description: "Buttons with images for 3 states stored in application icons location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-18 19:37:21 GMT (Tuesday 18th August 2020)"
	revision: "7"

class
	EL_SVG_BUTTON_PIXMAP_SET

inherit
	ANY

	EL_BUTTON_CONSTANTS

	EL_MODULE_ICON

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_SCREEN

	EL_MODULE_IMAGE_PATH

create
	make_default, make, make_transparent

feature {NONE} -- Initialization

	make (a_icon_path_steps: like icon_path_steps; width_cms: REAL; a_background_color: EL_COLOR)
			--
		do
			make_default
			icon_path_steps.grow (a_icon_path_steps.count + 1)
			icon_path_steps.append (a_icon_path_steps)
			background_color := a_background_color

			fill_pixmaps (width_cms)
		end

	make_default
		do
			create pixmap_table.make_equal (3)
			create background_color
			create icon_path_steps
			is_enabled := True
		end

	make_transparent (a_icon_path_steps: like icon_path_steps; width_cms: REAL)
		do
			make (a_icon_path_steps, width_cms, Icon.Transparent_color)
		end

feature -- Access

	background_color: EL_COLOR

	pixmap (state: ZSTRING): EV_PIXMAP
		do
			if pixmap_table.has_key (state) then
				Result := pixmap_table.found_item
			else
				create Result
			end
		end

feature -- Status query

	is_enabled: BOOLEAN
		-- True if button is sensitive (enabled)

feature -- Element change

	set_background_color (a_background_color: like background_color)
		do
			if background_color /~ a_background_color then
				across pixmap_table as l_pixmap loop
					l_pixmap.item.set_background_color (a_background_color)
				end
			end
			background_color := a_background_color
		end

feature -- Status setting

	set_disabled
		do
			is_enabled := False
		end

	set_enabled
		do
			is_enabled := True
		end

feature {NONE} -- Implementation

	fill_pixmaps (width_cms: REAL)
		do
			across Button_state_list as state loop
				set_pixmap (state.item, svg_icon (state.item + Dot_svg, width_cms))
			end
		end

	new_svg_image (svg_path: EL_FILE_PATH; width_cms: REAL): EL_SVG_PIXMAP
		do
			create Result.make_with_width_cms (svg_path, width_cms, background_color)
		end

	set_pixmap (name: ZSTRING; a_svg_icon: EV_PIXMAP)
		do
			pixmap_table [name] := a_svg_icon
		end

	svg_icon (last_step: ZSTRING; width_cms: REAL): like new_svg_image
		do
			icon_path_steps.extend (last_step)
			Result := new_svg_image (Image_path.icon (icon_path_steps), width_cms)
			icon_path_steps.remove_tail (1)
		end

feature {NONE} -- Internal attributes

	icon_path_steps: EL_PATH_STEPS

	pixmap_table: EL_ZSTRING_HASH_TABLE [EV_PIXMAP]

feature {NONE} -- Constants

	Clicked_border_color: ZSTRING
		once
			Result := "efebe3"
		end

	Clicked_border_width: CHARACTER = '6'

	Dot_svg: ZSTRING
		once
			Result := ".svg"
		end

	Highlighted_stop_color: STRING = "f9ffff"

end
