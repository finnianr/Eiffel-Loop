note
	description: "[
		Fractal image model world
		
		(First class to make use of ${EL_BOOLEAN_OPTION})
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	FRACTAL_MODEL_WORLD

inherit
	EV_MODEL_WORLD

	EL_MODULE_COLOR

	SHARED_FRACTAL_CONFIG

create
	make

feature {NONE} -- Initialization

	make (initial_width_cms: REAL; a_layer_list: like master_list)
		local
			l_dimensions: EL_RECTANGLE
		do
			default_create
			master_list := a_layer_list; layer_list := a_layer_list

			create background_image
			background_image.set_with_named_file (fractal_config.background_image_path)
			relative_background_height := background_image.height / background_image.width

			create l_dimensions.make_cms (0, 0, initial_width_cms, 0)
			l_dimensions.set_height ((background_image.height * l_dimensions.width / background_image.width).rounded)

			create root_image
			create opacity_graduation
			create root_image_at_top.make_with_action (True, agent invert_layers)

			create rectangle.make_rectangle (0, 0, l_dimensions.width, l_dimensions.height)
			rectangle.set_background_color (Color.Gray)
			rectangle.set_foreground_color (Color.White)
		end

feature -- Access

	dimensions: EL_RECTANGLE
		do
			create Result.make (0, 0, rectangle.width, rectangle.height)
		end

	rectangle: EV_MODEL_RECTANGLE
		-- back ground rectangle

	relative_background_height: DOUBLE
		-- background height relative to the background width

	root_image: REPLICATED_IMAGE_MODEL

feature -- Status query

	opacity_graduation: EL_BOOLEAN_OPTION

	root_image_at_top: EL_BOOLEAN_OPTION
		-- if enabled, root image is the final layer to be drawn

feature -- Element change

	resize_rectangle (cell: EL_RECTANGLE)
		local
			l_height, l_width: INTEGER
		do
			if relative_background_height > cell.height / cell.width then
				l_height := cell.height
				l_width := (background_image.width * cell.height / background_image.height).rounded
			else
				l_width := cell.width
				l_height := (background_image.height * cell.width / background_image.width).rounded
			end
			if l_width /= rectangle.width or l_height /= rectangle.height then
				rectangle.set_width (l_width); rectangle.set_height (l_height)
				rescale
			end
		end

feature -- Basic operations

	add_layer
		do
			master_list.add_layer
			rescale
		end

	drawable_rectangle: EL_RECTANGLE
		local
			border_width: INTEGER
		do
			Result := rectangle.bounding_box
			border_width := (Result.height * fractal_config.border_percent / 100).rounded

			Result.grow_top (border_width.opposite)
			Result.grow_bottom (border_width.opposite)
			Result.grow_left (border_width.opposite)
			Result.grow_right (border_width.opposite)
		end

	refill
		do
			wipe_out
			extend (rectangle)
			across layer_list as layer loop
				layer.item.fill_world (Current)
			end
		end

	rescale
		do
			layer_list := master_list.scaled (drawable_rectangle)
			if root_image_at_top.is_enabled then
				layer_list.reverse
			end
			refill
		end

	reset_layers
		do
			master_list.reset
			add_layer
		end

feature -- Conversion

	as_picture: EV_MODEL_PICTURE
		do
			create Result.make_with_pixmap (rendered_drawing.to_pixmap)
		end

feature {NONE} -- Implementation

	invert_layers (reversed: BOOLEAN)
		do
			layer_list.reverse
			refill
		end

	rendered_drawing: CAIRO_DRAWING_AREA
		local
			opacity, minimum_opacity, decrement: DOUBLE
		do
			create Result.make_with_size (rectangle.width, rectangle.height)
			Result.draw_scaled_pixmap ({EL_DIRECTION}.By_width, 0, 0, rectangle.width, background_image)

			opacity := fractal_config.fading.maximum / 100
			minimum_opacity := fractal_config.fading.minimum / 100
			decrement := (opacity - minimum_opacity) / (layer_list.count - 1)

			across layer_list as layer loop
				if opacity_graduation.is_enabled then
					Result.set_opacity ((100 * opacity).rounded.min (100))
					opacity := opacity - decrement
				else
					Result.set_opaque
				end
				layer.item.do_all (agent {REPLICATED_IMAGE_MODEL}.render (Result))
			end
		end

feature {NONE} -- Internal attributes

	background_image: EV_PIXMAP

	layer_list: FRACTAL_LAYER_LIST

	master_list: FRACTAL_LAYER_LIST

end