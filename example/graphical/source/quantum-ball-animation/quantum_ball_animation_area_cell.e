note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:32:12 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	QUANTUM_BALL_ANIMATION_AREA_CELL

inherit
	EV_MODEL_WORLD_CELL
		redefine
			initialize
		end

create
	make_with_world

feature {NONE} -- Initialization

	initialize
			-- Initialize `Current'.
		do
			Precursor {EV_MODEL_WORLD_CELL}
			disable_resize
			disable_scrollbars
			projector.register_figure (create {MODEL_ELECTRON}, agent projector.draw_figure_picture)

		end

end
