note
	description: "Summary description for {EL_EXPANDABLE_SCROLLABLE_AREA_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_EXPANDABLE_SCROLLABLE_AREA_IMP

inherit
	EL_EXPANDABLE_SCROLLABLE_AREA_I
		undefine
			copy, default_create, propagate_foreground_color, propagate_background_color
		redefine
			interface
		end

	EV_CELL_IMP
		redefine
			interface
		end

create
	make

feature {EL_EXPANDABLE_SCROLLABLE_AREA} -- Element change

	on_initial_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
--			log.enter_with_args ("resize_action", << a_x, a_y, a_width, a_height >>)
--			if a_width >= interface.scroll_area.item.minimum_width then
--				interface.scroll_area.set_item_width (a_width)
--			end
--			log.put_integer_field ("scroll_area.item.height", scroll_area.item.height)
--			log.exit
		end

	interface: EL_EXPANDABLE_SCROLLABLE_AREA

end
