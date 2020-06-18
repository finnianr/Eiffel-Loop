note
	description: "Model world cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-18 8:16:16 GMT (Thursday 18th June 2020)"
	revision: "3"

class
	EL_MODEL_WORLD_CELL

inherit
	EV_MODEL_WORLD_CELL
		redefine
			new_projector
		end

create
	make_with_world, default_create

feature {NONE} -- Implementation

	new_projector: EL_MODEL_BUFFER_PROJECTOR
		do
			create Result.make (world, drawing_area)
		end

end
