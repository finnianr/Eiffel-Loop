note
	description: "Progress toggle button box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-15 6:55:40 GMT (Saturday 15th June 2019)"
	revision: "1"

class
	EL_PROGRESS_TOGGLE_BUTTON_BOX

inherit
	EL_PROGRESS_BUTTON_BOX [EV_TOGGLE_BUTTON]

create
	make_with_text_and_action, make_with_tick_count

feature -- Status query

	is_selected: BOOLEAN
		do
			Result := item.is_selected
		end

end
