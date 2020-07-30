note
	description: "Model buffer projector extensions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 11:32:55 GMT (Sunday 28th June 2020)"
	revision: "8"

class
	EL_MODEL_BUFFER_PROJECTOR

inherit
	EV_MODEL_BUFFER_PROJECTOR
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
