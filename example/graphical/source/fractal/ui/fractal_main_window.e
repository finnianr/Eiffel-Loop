note
	description: "Fractal main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 13:27:48 GMT (Wednesday 29th May 2019)"
	revision: "3"

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

create
	make

feature {NONE} -- Initialization

	initialize
   			--
		do
			Precursor
			set_title (Window_title)
			show_actions.extend_kamikaze (agent on_show)
		end

feature {NONE} -- Event handler

	on_show
			--
		do
			model_cell.add_fractal
		end

feature {NONE} -- Create UI

	prepare_to_show
			--
		do
			set_minimum_size (Screen.horizontal_pixels (32), Screen.vertical_pixels (30))
			create border_box.make (0, 0)
			create model_cell.make

			border_box.set_background_color (model_cell.background_color)
			border_box.extend_unexpanded (new_control_bar)
			border_box.extend (model_cell)

			model_cell.disable_scrollbars
			extend (border_box)
			center_window
		end

feature {NONE} -- Factory

	new_control_bar: EL_HORIZONTAL_BOX
		do
			create Result.make_unexpanded (0.2, 0.2, <<
				create {EV_BUTTON}.make_with_text_and_action ("Add layer", agent model_cell.add_layer),
				create {EV_BUTTON}.make_with_text_and_action ("Invert layers", agent model_cell.invert_layers)
			>>)
		end

feature {NONE} -- Internal attributes

	border_box: EL_VERTICAL_BOX

	model_cell: FRACTAL_WORLD_CELL

feature {NONE} -- Constants

	Border_width_cms: REAL = 0.5

	Window_title: STRING = "Fractals"
			-- Title of the window.

end
