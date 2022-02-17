note
	description: "Buttons with images for 3 states stored in application icons location"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-17 10:46:58 GMT (Thursday 17th February 2022)"
	revision: "10"

class
	EL_SVG_BUTTON_PIXMAP_SET

inherit
	ARRAY [EL_SVG_PIXMAP]
		rename
			make as make_array,
			item as svg_item,
			valid_index as valid_state
		export
			{NONE} all
			{ANY} valid_state
		end

	EL_SHARED_BUTTON_STATE

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
			icon_path_steps.append_path (a_icon_path_steps)
			background_color := a_background_color

			fill_pixmaps (width_cms)
		end

	make_default
		do
			make_filled (Default_pixmap, 1, Button_state.count)
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

	pixmap (state: NATURAL_8): EL_PIXMAP
		require
			valid_state: Button_state.is_valid_value (state)
		do
			Result := svg_item (state.to_integer_32)
		end

	drawing_area (state: NATURAL_8): CAIRO_DRAWING_AREA
		require
			valid_state: Button_state.is_valid_value (state)
		local
			png_output_path: FILE_PATH
		do
			png_output_path := svg_item (state).png_output_path
			if png_output_path.exists then
				create Result.make_with_path (png_output_path)
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
				across Current as l_pixmap loop
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
			across Button_state.list as state loop
				set_pixmap (state.item, svg_icon (state.item, width_cms))
			end
		end

	new_svg_image (svg_path: FILE_PATH; width_cms: REAL): EL_SVG_PIXMAP
		do
			create Result.make_with_width_cms (svg_path, width_cms, background_color)
		end

	set_pixmap (state: NATURAL_8; a_svg_icon: EL_SVG_PIXMAP)
		do
			put (a_svg_icon, state)
		end

	svg_icon (a_state: NATURAL_8; width_cms: REAL): like new_svg_image
		do
			icon_path_steps.extend (svg_name (a_state))
			Result := new_svg_image (Image_path.icon (icon_path_steps), width_cms)
			icon_path_steps.remove_tail (1)
		end

	svg_name (state: NATURAL_8): ZSTRING
		local
			name: STRING
		do
			name := Button_state.name (state.item)
			create Result.make (name.count + 4)
			Result.append_string_general (name)
			Result.append (Dot_svg)
		end

feature {NONE} -- Internal attributes

	icon_path_steps: EL_PATH_STEPS

feature {NONE} -- Constants

	Clicked_border_color: ZSTRING
		once
			Result := "efebe3"
		end

	Clicked_border_width: CHARACTER = '6'

	Default_pixmap: EL_SVG_PIXMAP
		once
			create Result
		end

	Dot_svg: ZSTRING
		once
			Result := ".svg"
		end

	Highlighted_stop_color: STRING = "f9ffff"

end