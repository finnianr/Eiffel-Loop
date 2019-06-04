note
	description: "Model group"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-02 18:32:20 GMT (Sunday 2nd June 2019)"
	revision: "1"

class
	EL_MODEL_GROUP

inherit
	EV_MODEL_GROUP

create
	default_create, make_with_point, make_with_position, make

feature {NONE} -- Initialization

	make (iterable: ITERABLE [EV_MODEL])
		do
			default_create
			if attached {FINITE [EV_MODEL]} iterable as finite then
				grow (finite.count)
				across iterable as model loop
					extend (model.item)
				end
			end
			center_invalidate
			invalidate
			full_redraw
		end

end
