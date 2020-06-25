note
	description: "Model world cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-25 9:49:41 GMT (Thursday 25th June 2020)"
	revision: "4"

class
	EL_MODEL_WORLD_CELL

inherit
	EV_MODEL_WORLD_CELL
		redefine
			new_projector
		end

create
	make_with_world, default_create

feature -- Access

	screen_origin: EL_COORDINATE
		-- screen coordinates of world origin (top left)
		do
			create Result.make (screen_x - projector.area_x, screen_y - projector.area_y)
		end

	screen_position (model_point: EV_COORDINATE): EL_COORDINATE
		-- screen position of point on model
		do
			Result := screen_origin
			Result.set (Result.x + model_point.x, Result.y + model_point.y)
		end

feature {NONE} -- Implementation

	new_projector: EL_MODEL_BUFFER_PROJECTOR
		do
			create Result.make (world, drawing_area)
		end

end
