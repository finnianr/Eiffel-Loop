note
	description: "Fractal image model world"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-30 10:54:25 GMT (Thursday 30th May 2019)"
	revision: "3"

class
	FRACTAL_IMAGE_MODEL_WORLD

inherit
	EV_MODEL_WORLD

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			create layer_list.make (20)
			new_branch_list := agent default_branch_list
			is_seed_top_layer := True
		end

feature -- Status query

	is_seed_top_layer: BOOLEAN

feature -- Access

	bounding_rectangle: EL_RECTANGLE
		local
			points: SPECIAL [EV_COORDINATE]; i: INTEGER
		do
			points := layer_list.first.first.point_array
			create Result.make (points.item (0).x, points.item (0).y, 0, 0)
			across layer_list as branch_list loop
				across branch_list.item as branch_image loop
					points := branch_image.item.point_array
					from i := 0 until i = points.count loop
						Result.include_point (points [i])
						i := i + 1
					end
				end
			end
		end

feature -- Basic operations

	add_layer
		local
			new_layer: like layer_list.last
		do
			create new_layer.make (10)
			across layer_list.last as branch_image loop
				new_layer.append (new_branch_list (branch_image.item))
			end
			layer_list.extend (new_layer)
			across new_layer as branch_image loop
				if is_seed_top_layer then
					put_front (branch_image.item)
				else
					extend (branch_image.item)
				end
			end
		end

	invert_layers
		do
			is_seed_top_layer := not is_seed_top_layer
			wipe_out
			across new_layer_iterator as branch_list loop
				across branch_list.item as branch_image loop
					extend (branch_image.item)
				end
			end
		end

	set_fractal (seed_image: REPLICATED_IMAGE_MODEL; a_new_branch_list: like new_branch_list)
		local
			new_layer: like layer_list.item
		do
			new_branch_list := a_new_branch_list
			create new_layer.make (1)
			new_layer.extend (seed_image)
			layer_list.extend (new_layer)

			extend (seed_image)
			add_layer
		end

feature {NONE} -- Implementation

	default_branch_list (a_parent: REPLICATED_IMAGE_MODEL): ARRAYED_LIST [REPLICATED_IMAGE_MODEL]
		do
			create Result.make (0)
		end

	new_layer_iterator: ITERABLE [like default_branch_list]
		do
			if is_seed_top_layer then
				Result := layer_list.new_cursor.reversed
			else
				Result := layer_list.new_cursor
			end
		end

feature {NONE} -- Internal attributes

	layer_list: ARRAYED_LIST [like default_branch_list]

	new_branch_list: FUNCTION [REPLICATED_IMAGE_MODEL, like default_branch_list]

end
