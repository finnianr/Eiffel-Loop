note
	description: "Fractal main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:07:53 GMT (Monday 1st July 2019)"
	revision: "7"

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

	EL_MODULE_ICON

	EL_MODULE_VISION_2

	SHARED_FRACTAL_CONFIG

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
			model_cell.add_layer
		end

feature {NONE} -- Create UI

	prepare_to_show
			--
		do
			create model_cell.make

			create border_box.make (0.25, 0.2)
			border_box.extend_unexpanded (new_control_bar)
			border_box.extend (model_cell)

			border_box.set_background_color (Color.Black)

			extend (border_box)
			center_window
		end

feature {NONE} -- Factory

	new_control_bar: EL_VERTICAL_BOX
		local
			fading_button: EV_TOGGLE_BUTTON
		do
			create fading_button.make_with_text ("Fading on")
			fading_button.select_actions.extend (agent model_cell.invert_fading (fading_button))

			create Result.make_unexpanded (0, 0.25, <<
				create {EV_BUTTON}.make_with_text_and_action ("Add layer", agent model_cell.add_layer),
				create {EV_BUTTON}.make_with_text_and_action ("Add background", agent model_cell.render_as_pixmap),
				fading_button,
				create {EV_BUTTON}.make_with_text_and_action ("Invert layers", agent model_cell.invert_layers),
				create {EV_BUTTON}.make_with_text_and_action ("Reset layers", agent model_cell.reset_layers)
			>>)
			Result.set_background_color (Color.Black)
		end

feature {NONE} -- Internal attributes

	border_box: EL_HORIZONTAL_BOX

	model_cell: FRACTAL_WORLD_CELL

feature {NONE} -- Constants

	Border_width_cms: REAL = 0.5

	Window_title: STRING = "Fractal"
			-- Title of the window.

end
