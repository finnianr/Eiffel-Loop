note
	description: "Fractal world cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 16:30:57 GMT (Wednesday 29th May 2019)"
	revision: "2"

class
	FRACTAL_WORLD_CELL

inherit
	EV_MODEL_WORLD_CELL
		redefine
			world
		end

	EL_MODULE_COLOR
		undefine
			default_create, copy
		end

	EL_MODEL_MATH
		rename
			log as natural_log
		undefine
			default_create, copy
		end

	SHARED_FRACTAL_CONFIG
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create world.make
			world.set_background_color (Color_background)
			default_create
			set_background_color (Color_background)
			create replicated_image.make_with_path (fractal_config.image_path)
		end

feature -- Basic operations

	add_fractal
		local
			seed_image: IMAGE_PLACEHOLDER_MODEL
			rectangle, cell_rectangle: EL_RECTANGLE
		do
			create cell_rectangle.make (0, 0, width, height)
			create rectangle.make (0, 0, replicated_image.width, replicated_image.height)
			rectangle.move_center (cell_rectangle)

			create seed_image.make (rectangle)
			world.set_fractal (seed_image, agent new_branch_list)

			center_fractal
			resize_if_necessary
		end

	add_layer
		do
			world.add_layer
			center_fractal
		end

	invert_layers
		do
			world.invert_layers
			projector.project
		end

feature {NONE} -- Factory

	new_branch_list (a_parent: IMAGE_PLACEHOLDER_MODEL): ARRAYED_LIST [IMAGE_PLACEHOLDER_MODEL]
		local
			branch: IMAGE_PLACEHOLDER_MODEL
		do
			create Result.make (3)
			create branch.make_satellite (a_parent, 0.7, 1, 0)
			branch.rotate (radians (45))
			Result.extend (branch)

			create branch.make_satellite (a_parent, 0.7, 1, radians (90))
			Result.extend (branch)
--			branch.rotate (radians (90))

			create branch.make_satellite (a_parent, 0.7, 1, radians (180))
			branch.rotate (-radians (45))
			Result.extend (branch)
		end

feature {NONE} -- Implementation

	center_fractal
		local
			display_rectangle, fractal_rectangle: EL_RECTANGLE
			x, y: INTEGER
		do
			create display_rectangle.make (0, 0, width, height)
			fractal_rectangle := world.bounding_rectangle
			x := fractal_rectangle.x; y := fractal_rectangle.y
			fractal_rectangle.move_center (display_rectangle)

			projector.change_area_position (x - fractal_rectangle.x, y - fractal_rectangle.y)

			projector.project
		end

feature {NONE} -- Internal attributes

	world: FRACTAL_IMAGE_MODEL_WORLD

	replicated_image: EL_DRAWABLE_PIXEL_BUFFER

feature {NONE} -- Constants

	Color_background: EV_COLOR
		once
			Result := Color.Dark_green
		end

end
