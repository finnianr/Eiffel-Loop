note
	description: "[
		Object for managing a list of updateable widget components.
		
		The automatic array conversion does not work as intended due to the limitations in
		Eiffel ARRAY manifest conformance checking in compiler version 16.05, but perhaps in
		a future version it will be useable.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-28 11:16:11 GMT (Thursday 28th September 2017)"
	revision: "2"

class
	EL_MANAGED_WIDGET_LIST

inherit
	ARRAYED_LIST [EL_MANAGED_WIDGET [EV_WIDGET]]
		rename
			make_from_array as make,
			make as make_with_count
		end

create
	make

convert
	make ({ARRAY [EL_MANAGED_WIDGET [EV_WIDGET]]})

feature -- Basic operations

	update_all
		do
			from start until after loop
				item.update
				forth
			end
		end

end
