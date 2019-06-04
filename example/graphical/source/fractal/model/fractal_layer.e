note
	description: "Fractal layer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-04 13:53:49 GMT (Tuesday 4th June 2019)"
	revision: "1"

class
	FRACTAL_LAYER

inherit
	ARRAYED_LIST [REPLICATED_IMAGE_MODEL]
		rename
			make as make_list
		end

	SHARED_FRACTAL_CONFIG
		undefine
			copy, is_equal
		end

create
	make, make_first

feature {NONE} -- Initialization

	make (parent: like Current)
		do
			make_list (0)
			if not parent.is_empty then
				-- Test how many new ones are created and resize appropriately
				parent.start
				fractal_config.append_to_layer (parent.item, Current)
				grow (count * parent.count)

				from parent.forth until parent.after loop
					fractal_config.append_to_layer (parent.item, Current)
					parent.forth
				end
			end
		end

	make_first (model: REPLICATED_IMAGE_MODEL)
		do
			make_list (1)
			extend (model)
		end

feature -- Basic operations

	fill_world (world: FRACTAL_MODEL_WORLD)
		do
			across Current as model loop
				world.extend (model.item)
			end
		end

feature -- Measurement

	bounding_rectangle: EL_RECTANGLE
		local
			points: SPECIAL [EV_COORDINATE]; i: INTEGER
		do
			create Result
			across Current as model loop
				points := model.item.point_array
				if model.cursor_index = 1 then
					Result.set_x (points.item (0).x)
					Result.set_y (points.item (0).y)
				end
				from i := 0 until i = points.count loop
					Result.include_point (points [i])
					i := i + 1
				end
			end
		end

end
