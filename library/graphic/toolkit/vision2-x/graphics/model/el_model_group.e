note
	description: "Model group"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_MODEL_GROUP

inherit
	EV_MODEL_GROUP

	EL_MODULE_ITERABLE

create
	default_create, make_with_point, make_with_position, make

feature {NONE} -- Initialization

	make (list: ITERABLE [EV_MODEL])
		do
			default_create
			grow (Iterable.count (list))
			across list as model loop
				extend (model.item)
			end
			center_invalidate
			invalidate
			full_redraw
		end

end