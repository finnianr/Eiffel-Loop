note
	description: "Summary description for {EL_EXPANDABLE_SCROLLABLE_AREA_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-28 12:18:08 GMT (Tuesday 28th May 2013)"
	revision: "2"

class
	EL_EXPANDABLE_SCROLLABLE_AREA_IMP

inherit
	EL_EXPANDABLE_SCROLLABLE_AREA_I
		undefine
			copy, default_create
		redefine
			interface
		end

	EV_CELL_IMP
		redefine
			interface
		end

	EL_MODULE_LOG

create
	make

feature {EL_EXPANDABLE_SCROLLABLE_AREA} -- Implementation


	on_initial_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
			if interface.scroll_area.item.height < a_height then
				interface.scroll_area.hide_vertical_scroll_bar
			else
				interface.scroll_area.show_vertical_scroll_bar
			end
			interface.scroll_area.item.set_minimum_size ((a_width - 1).max (0), (a_height - 1).max (0))
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
--			log.enter_with_args ("on_resize", << a_x, a_y, a_width, a_height >>)
			if a_height > interface.scroll_area.item.minimum_height then
				interface.scroll_area.item.set_minimum_height ((a_height - 1).max (0))
			end

--			log.put_integer_field ("scroll_area.width", interface.scroll_area.item.width)
--			log.put_new_line
--			log.put_integer_field ("scroll_area.height", interface.scroll_area.item.height)
--			log.exit
		end

--	interface: detachable EL_EXPANDABLE_SCROLLABLE_AREA note option: stable attribute end;
	interface: EL_EXPANDABLE_SCROLLABLE_AREA

	original_height: INTEGER
end
