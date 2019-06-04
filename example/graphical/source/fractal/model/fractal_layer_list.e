note
	description: "Fractal layer list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-04 19:28:38 GMT (Tuesday 4th June 2019)"
	revision: "1"

class
	FRACTAL_LAYER_LIST

inherit
	ARRAYED_LIST [FRACTAL_LAYER]
		rename
			make as make_list
		end

create
	make

feature {NONE} -- Initialization

	make (a_root_image: REPLICATED_IMAGE_MODEL)
		do
			make_list (10)
			root_image := a_root_image
			extend (create {like item}.make_first (root_image))
		end

feature -- Access

	root_image: REPLICATED_IMAGE_MODEL

	scaled (rectangle: EL_RECTANGLE): like Current
		local
			bounding, scaled_bounding: like bounding_rectangle
			width_proportion, height_proportion, proportion, relative_x, relative_y, scaled_x, scaled_y: DOUBLE
			root_model: REPLICATED_IMAGE_MODEL
			position: EV_COORDINATE i: INTEGER
		do
			bounding := bounding_rectangle
			width_proportion := rectangle.width / bounding.width
			height_proportion := rectangle.height / bounding.height
			if width_proportion <= height_proportion then
				proportion := width_proportion
			else
				proportion := height_proportion
			end
			create scaled_bounding.make_from_other (bounding)
			scaled_bounding.scale (proportion.truncated_to_real)
			scaled_bounding.move_center (rectangle)

			relative_x := (root_image.center.x_precise - bounding.x) / bounding.width
			relative_y := (root_image.center.y_precise - bounding.y) / bounding.height
			scaled_x := relative_x * scaled_bounding.width
			scaled_y := relative_y * scaled_bounding.height

			create position.make_precise (scaled_bounding.x + scaled_x, scaled_bounding.y + scaled_y)
			create root_model.make_scaled (root_image, position, proportion)
			create Result.make (root_model)
			from i := 2 until i > count loop
				Result.add_layer
				i := i + 1
			end
		end

feature -- Measurement

	bounding_rectangle: EL_RECTANGLE
		do
			create Result
			across Current as layer loop
				if layer.cursor_index = 1 then
					Result.copy (layer.item.bounding_rectangle)
				else
					Result.merge (layer.item.bounding_rectangle)
				end
			end
		end

feature -- Element change

	add_layer
		do
			extend (create {like item}.make (last))
		end

	reset
		local
			layer: like item
		do
			layer := first
			wipe_out
			extend (layer)
		end

	reverse
		local
			l_area: like area
		do
			create l_area.make_empty (count)
			across new_cursor.reversed as layer loop
				l_area.extend (layer.item)
			end
			area_v2 := l_area
		end

end
