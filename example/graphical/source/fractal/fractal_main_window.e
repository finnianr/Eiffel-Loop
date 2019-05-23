note
	description: "Fractal main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-23 17:43:02 GMT (Thursday 23rd May 2019)"
	revision: "1"

class
	FRACTAL_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW
		rename
			background_color as window_background_color
		redefine
			 initialize, prepare_to_show
		end

	EL_MODULE_COLOR
		undefine
			copy , default_create
		end

	EL_MODULE_ICON
		undefine
			copy , default_create
		end

	DOUBLE_MATH
		rename
			log as natural_log
		undefine
			copy , default_create
		end

create
	make

feature {NONE} -- Initialization

	initialize
   			--
		do
			Precursor
			set_title (Window_title)
		end


feature {NONE} -- Event handler

	on_show
			--
		do
		end

feature {NONE} -- Create UI

	prepare_to_show
			--
		do
			set_minimum_size (Screen.horizontal_pixels (24), Screen.vertical_pixels (24))
			create border_box.make (Border_width_cms, 0)
			border_box.set_background_color (Background_color)
			create model_cell.make_with_world (new_model)
			model_cell.set_background_color (Color.Black)
			border_box.extend (model_cell)

			model_cell.disable_scrollbars
			model_cell.projector.project

			extend (border_box)
			center_window
		end

feature {NONE} -- Implementation

	new_model: EV_MODEL_WORLD
		local
			p1, p2: IMAGE_PLACEHOLDER_MODEL
		do
			create p1.make ([5.0, 5.0, 5.0, 7.0])

			create p2.make_satellite (p1, 0.5, 1, Pi / 2)
			p2.rotate (Pi / 2)

			create Result
			Result.extend (p1)
			Result.extend (p2)
			Result.set_background_color (Background_color)
		end

feature {NONE} -- Internal attributes

	border_box: EL_VERTICAL_BOX

	model_cell: EV_MODEL_WORLD_CELL

feature {NONE} -- Constants

	Background_color: EV_COLOR
		once
			Result := Color.Dark_green
		end

	Border_width_cms: REAL = 0.5

	Window_title: STRING = "Fractals"
			-- Title of the window.

end
