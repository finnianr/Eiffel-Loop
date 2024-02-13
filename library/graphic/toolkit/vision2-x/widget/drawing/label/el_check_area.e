note
	description: "Widget that displays a checked/unchecked status icon depending on state `is_checked'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-13 12:12:10 GMT (Tuesday 13th February 2024)"
	revision: "6"

class
	EL_CHECK_AREA

inherit
	EL_DRAWING_AREA_BASE
		export
			{NONE} all
		end

	EL_MODULE_SCREEN

	EL_MODULE_ORIENTATION

create
	make

feature {NONE} -- Initialization

	make (a_icon_path_set: like icon_path_set; a_width: INTEGER)
		require
			images_exists: a_icon_path_set.all_exist
		local
			rect: EL_RECTANGLE
		do
			default_create
			icon_path_set := a_icon_path_set
			create checked_drawing_area.make_with_function (agent new_drawing_area)
			rect := checked_drawing_area [True]
			rect.scale_to_width (a_width)
			create canvas.make_with_rectangle (rect)
			set_minimum_size (rect.width, rect.height)
			set_expose_actions
		end

feature -- Status query

	is_checked: BOOLEAN

feature -- Status change

	set_checked (state: BOOLEAN)
		do
			is_checked := state
			redraw
		end

feature {NONE} -- Event handlers

	on_redraw (a_x, a_y, a_width, a_height: INTEGER)
		do
			fill_rectangle (0, 0, width, height)
			canvas.set_color (background_color)
			canvas.fill
			canvas.draw_scaled_in_dimension (Orientation.By_width, 0, 0, width, image)
			draw_pixel_buffer (0, 0, canvas.to_buffer)
		end

feature {NONE} -- Implementation

	image: CAIRO_DRAWING_AREA
		do
			Result := checked_drawing_area [is_checked]
		end

	new_drawing_area (checked: BOOLEAN): CAIRO_DRAWING_AREA
		do
			Result := icon_path_set [checked]
		end

feature {NONE} -- Internal attributes

	canvas: CAIRO_DRAWING_AREA

	checked_drawing_area: EL_BOOLEAN_INDEXABLE [CAIRO_DRAWING_AREA]

	icon_path_set: EL_FILE_PATH_BINARY_SET
end