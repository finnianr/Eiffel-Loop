note
	description: "Viewport with horizontally centered content"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CENTERED_VIEWPORT

inherit
	EV_VIEWPORT
		redefine
			initialize
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
		do
			Precursor {EV_VIEWPORT}
			resize_actions.extend (agent on_resize)
		end

feature {NONE} -- Event Handling

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		local
			item_width: INTEGER
		do
			if readable and a_width > 0 then
				item.set_minimum_width (width)
				item_width := item.width
				if item_width > a_width then
					set_x_offset ((item_width - a_width) // 2)
				end
			end
		end

end
