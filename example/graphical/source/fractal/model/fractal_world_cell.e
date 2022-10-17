note
	description: "Fractal fractal_world cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 18:24:53 GMT (Monday 17th October 2022)"
	revision: "8"

class
	FRACTAL_WORLD_CELL

inherit
	EL_MODEL_WORLD_CELL

	EL_MODULE_COLOR

	EL_MODULE_SCREEN

	EL_MODULE_LIO

	EL_MODULE_ACTION

	SHARED_FRACTAL_CONFIG

create
	make

feature {NONE} -- Initialization

	make
		do
			create pixmap_world
			pixmap_world.set_background_color (Color.Black)

			create fractal_world.make (32, fractal_config.root_layer)
			fractal_world.set_background_color (Color_background)

			world := fractal_world
			default_create
			disable_scrollbars

			set_minimum_size (fractal_world.rectangle.width, fractal_world.rectangle.height)

			set_background_color (Color.Black)
			Action.do_once_on_idle (agent set_resize_actions)
		end

feature -- Basic operations

	add_layer
		do
			fractal_world.add_layer
			update
		end

	invert_fading (button: EV_TOGGLE_BUTTON)
		do
			if button.is_selected then
				button.set_text ("Fading off")
			else
				button.set_text ("Fading on")
			end
			fractal_world.opacity_graduation.invert
			update
		end

	invert_layers
		do
			fractal_world.root_image_at_top.invert
			fractal_world.refill
			update
		end

	render_as_pixmap
		do
			pixmap_world.extend (fractal_world.as_picture)
			set_world (pixmap_world)
			projector.project
		end

	reset_layers
		do
			fractal_world.reset_layers
			update
		end

	update
		do
			if is_rendered_to_pixmap then
				pixmap_world.start
				pixmap_world.replace (fractal_world.as_picture)
			end
			projector.project
		end

feature -- Status query

	is_rendered_to_pixmap: BOOLEAN
		do
			Result := world = pixmap_world
		end

feature {NONE} -- Event handling

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		local
			rectangle, area: EL_RECTANGLE
		do
			create area.make (0, 0, a_width, a_height)
			fractal_world.resize_rectangle (area)
			update
			rectangle := fractal_world.dimensions
			rectangle.move_center (area)
			projector.change_area_position (rectangle.x.opposite, rectangle.y.opposite)
		end

feature {NONE} -- Implementation

	cell_rectangle: EL_RECTANGLE
		do
			create Result.make (0, 0, width, height)
		end

	set_resize_actions
		do
			resize_actions.extend (agent on_resize)
		end

	update_pixmap_world
		do
			pixmap_world.start
			pixmap_world.replace (fractal_world.as_picture)
			projector.project
		end

feature {NONE} -- Internal attributes

	fractal_world: FRACTAL_MODEL_WORLD

	pixmap_world: EV_MODEL_WORLD

feature {NONE} -- Constants

	Color_background: EV_COLOR
		once
			Result := Color.Highlight_3d
		end

end
