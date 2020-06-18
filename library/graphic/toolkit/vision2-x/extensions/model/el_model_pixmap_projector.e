note
	description: "Model pixmap projector"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-18 8:55:59 GMT (Thursday 18th June 2020)"
	revision: "1"

class
	EL_MODEL_PIXMAP_PROJECTOR

inherit
	EV_MODEL_PIXMAP_PROJECTOR
		undefine
			draw_figure_parallelogram
		end

	EL_MODEL_DRAWER
		undefine
			offset_x, offset_y
		end

create
	make, make_with_buffer

end
