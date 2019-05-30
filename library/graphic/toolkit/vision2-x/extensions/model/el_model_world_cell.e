note
	description: "Model world cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-30 9:49:28 GMT (Thursday 30th May 2019)"
	revision: "1"

class
	EL_MODEL_WORLD_CELL

inherit
	EV_MODEL_WORLD_CELL
		redefine
			new_projector
		end

create
	make_with_world

feature {NONE} -- Implementation

	new_projector: EV_MODEL_WIDGET_PROJECTOR
		do
			create {EL_MODEL_BUFFER_PROJECTOR} Result.make (world, drawing_area)
		end

end
