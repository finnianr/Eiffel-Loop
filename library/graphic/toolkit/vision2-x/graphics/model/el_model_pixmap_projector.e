note
	description: "Model pixmap projector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_MODEL_PIXMAP_PROJECTOR

inherit
	EV_MODEL_PIXMAP_PROJECTOR
		undefine
			draw_figure_parallelogram
		redefine
			make
		end

	EL_MODEL_DRAWER
		undefine
			offset_x, offset_y
		end

create
	make, make_with_buffer

feature {NONE} -- Initialization

	make (a_world: like world; a_pixmap: EV_PIXMAP)
			-- Create with `a_world' and `a_drawable' (= `a_widget').
		do
			make_with_drawable (a_pixmap)
				-- This is only for letting users who have defined their own figure to still be
				-- able to use the `register_figure'.
			create draw_routines.make_filled (Void, 0, 20)
			make_with_world (a_world)
			pixmap := a_pixmap
			project_agent := agent project
			area_x := 0
			area_y := 0
		end

end