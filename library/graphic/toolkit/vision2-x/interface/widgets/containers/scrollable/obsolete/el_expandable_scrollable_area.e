note
	description: "[
		Works on Unix
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_EXPANDABLE_SCROLLABLE_AREA

obsolete
	"Use EL_SCROLLABLE_VERTICAL_BOX or EL_SCROLLABLE_PAGE"

inherit
	EV_CELL
		redefine
			put, replace, has, set_background_color, readable, set_focus,
			create_implementation, implementation
		end

	EL_MODULE_GUI
		undefine
			default_create, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			create scroll_area
--			create inner_cell
			implementation.replace (scroll_area)
		end

feature -- Access

	scrollable_item: EV_WIDGET
		require
			readable: scrollable_item_readable
		do
			Result := scroll_area.item
		end

	scrollable_item_readable: BOOLEAN
		do
			Result := scroll_area.readable
		end

feature -- Status Query

	has (v: EV_WIDGET): BOOLEAN
			-- Does `Current' include `v'?
		do
			Result := scroll_area.has (v)
		end

	readable: BOOLEAN
		do
			Result := scroll_area.readable
		end

	is_vertical_bar_displayed: BOOLEAN
		do
			Result := scroll_area.item.height > height
		end

feature -- Status Setting

	set_focus
		do
			scroll_area.set_focus
		end

feature -- Element change

	put, replace (a_widget: EV_WIDGET)
		do
			scroll_area.replace (a_widget)
			GUI.do_once_on_idle (
				agent
					do
						implementation.on_initial_resize (x_position, y_position, width, height)
						resize_actions.extend (agent implementation.on_resize)
					end
			)
		end

--	replace (a_widget: EV_WIDGET)
--		do
--			create inner_cell
--			inner_cell.put (a_widget)
--			GUI.do_once_on_idle (agent init_inner_cell)
--			scroll_area.replace (inner_cell)
--		end

	set_background_color (a_color: like background_color)
		do
			Precursor (a_color)
			scroll_area.set_background_color (a_color)
		end

feature -- Element change

	set_x_offset (a_x: INTEGER)
			--
		do
			scroll_area.set_x_offset (a_x)
		end

	set_y_offset (a_y: INTEGER)
			--
		do
			scroll_area.set_y_offset (a_y)
		end

	hide_horizontal_scroll_bar
		do
			scroll_area.hide_horizontal_scroll_bar
		end

	hide_vertical_scroll_bar
		do
			scroll_area.hide_vertical_scroll_bar
		end

feature {EL_EXPANDABLE_SCROLLABLE_AREA_IMP} -- Implementation

	set_size_actions
		do
			implementation.on_resize (x_position, y_position, width, height)
--			if height > scroll_area.item.height then
--				scroll_area.item.set_minimum_height ((height - 1).max (0))
--			end
			resize_actions.extend (agent implementation.on_resize)
		end

	create_implementation
			--
		do
			create {EL_EXPANDABLE_SCROLLABLE_AREA_IMP} implementation.make
		end

	implementation: EL_EXPANDABLE_SCROLLABLE_AREA_I

	scroll_area: EL_SCROLLABLE_AREA

end
