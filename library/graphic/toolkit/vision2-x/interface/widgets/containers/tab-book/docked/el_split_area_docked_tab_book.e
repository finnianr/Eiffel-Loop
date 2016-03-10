note
	description: "Docking split area with tabbed area on left and place_holder on right"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_SPLIT_AREA_DOCKED_TAB_BOOK

inherit
	EL_DOCKED_TAB_BOOK
		redefine
			set_delivery_zone
		end

create
	make

feature -- Element change

	set_split_position_on_idle (a_width: INTEGER)
		do
--			GUI.do_once_on_idle (agent (manager.contents.last).set_split_position (a_position))
			GUI.do_once_on_idle (agent set_split_position (a_width))
		end

	set_split_position (a_width: INTEGER)
		do
			split_area.set_split_position (a_width)
		end

feature {NONE} -- Implementation

	set_delivery_zone
			-- set active zone to receive new tabs
		do
			-- Creates split area for adding new tabs on left side
			manager.contents.last.set_top ({SD_ENUMERATION}.left)
--			set_split_proportion_on_idle (Default_split_proportion)
		end

	split_area: SD_HORIZONTAL_SPLIT_AREA
		do
			if attached {SD_HORIZONTAL_SPLIT_AREA} inner_container_main.item as l_result then
				Result := l_result
			else
				create Result
			end
		end

end
