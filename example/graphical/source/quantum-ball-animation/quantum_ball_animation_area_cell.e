note
	description: "Quantum ball animation area cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
			Precursor
			disable_resize
			disable_scrollbars
			projector.register_figure (create {MODEL_ELECTRON}, agent projector.draw_figure_picture)

		end

end