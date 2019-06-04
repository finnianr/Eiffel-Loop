note
	description: "Fractal main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-04 13:45:51 GMT (Tuesday 4th June 2019)"
	revision: "5"

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

	EL_MODULE_VISION_2
		undefine
			copy , default_create
		end

	SHARED_FRACTAL_CONFIG
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
			model_cell.add_layer
		end

feature {NONE} -- Create UI

	prepare_to_show
			--
		do
			create model_cell.make

			create border_box.make (0, 0)
			border_box.extend_unexpanded (new_control_bar)
			border_box.extend (model_cell)

			border_box.set_background_color (Color.Black)

			extend (border_box)
			center_window
		end

feature {NONE} -- Factory

	new_control_bar: EL_HORIZONTAL_BOX
		local
			fading_button: EV_TOGGLE_BUTTON
		do
			create fading_button.make_with_text ("Fading on")
			fading_button.select_actions.extend (agent model_cell.invert_fading (fading_button))

			create Result.make_unexpanded (0.2, 0.2, <<
				create {EV_BUTTON}.make_with_text_and_action ("Add layer", agent model_cell.add_layer),
				create {EV_BUTTON}.make_with_text_and_action ("Invert layers", agent model_cell.invert_layers),
				create {EV_BUTTON}.make_with_text_and_action ("Render fractal", agent model_cell.render_as_pixmap),
				create {EV_BUTTON}.make_with_text_and_action ("Reset layers", agent model_cell.reset_layers),
				fading_button
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
