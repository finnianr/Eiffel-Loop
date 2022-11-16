note
	description: "Model buffer projector extensions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

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