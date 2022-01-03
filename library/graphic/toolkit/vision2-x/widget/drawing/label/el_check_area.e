note
	description: "Widget that displays a checked/unchecked status icon depending on state `is_checked'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "2"

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

	make (checked_image_path: FILE_PATH; a_width: INTEGER)
		require
			image_exists: checked_image_path.exists
			unchecked_image_exists: unchecked_image_path (checked_image_path).exists
		local
			rect: EL_RECTANGLE
		do
			default_create
			Cache_table.set_new_item_target (Current)
			internal_image := Cache_table.item (checked_image_path)

			rect := internal_image.checked
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
			canvas.draw_scaled_drawing_area (Orientation.By_width, 0, 0, width, image)
			draw_pixel_buffer (0, 0, canvas.to_buffer)
		end

feature {NONE} -- Implementation

	image: CAIRO_DRAWING_AREA
		do
			if is_checked then
				Result := internal_image.checked
			else
				Result := internal_image.unchecked
			end
		end

	new_image (checked_image_path: FILE_PATH): like Cache_table.item
		do
			create Result
			Result.checked := checked_image_path
			Result.unchecked := unchecked_image_path (checked_image_path)
		end

	unchecked_image_path (path: FILE_PATH): FILE_PATH
		do
			Result := path.parent + (Un_prefix + path.base)
		end

feature {NONE} -- Internal attributes

	canvas: CAIRO_DRAWING_AREA

	internal_image: like Cache_table.item

feature {NONE} -- Constants

	Cache_table: EL_CACHE_TABLE [TUPLE [checked, unchecked: CAIRO_DRAWING_AREA], FILE_PATH]
		once
			create Result.make_equal (5, agent new_image)
		end

	Un_prefix: ZSTRING
		once
			Result := "un"
		end
end
