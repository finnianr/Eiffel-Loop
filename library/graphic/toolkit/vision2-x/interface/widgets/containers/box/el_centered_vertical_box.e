note
	description: "Summary description for {EL_CENTERED_CELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_CENTERED_VERTICAL_BOX

inherit
	EL_HORIZONTAL_BOX
		rename
			set_background_color as set_border_color,
			background_color as border_color,
			extend as box_extend,
			extend_unexpanded as box_extend_unexpanded
		export
			{NONE} all
			{ANY} set_border_color, propagate_background_color, set_minimum_height, height, is_destroyed,
					 mouse_wheel_actions, new_cursor, border_color,
					 prunable, extendible, same, is_parent_recursive, may_contain
		redefine
			make, set_border_color, append_unexpanded, initialize
		end

	EL_MODULE_GUI
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

create
	make, default_create

feature {NONE} -- Initialization

	initialize
		do
			create border_box
			create left_border; create right_border; create top_border; create bottom_border
			create box.make (border_cms, padding_cms)
			Precursor
		end

	make (a_border_cms, a_padding_cms: REAL)
		do
			border_cms := a_border_cms; padding_cms := a_padding_cms
			Precursor (0, 0)
			border_box.extend_unexpanded (top_border)
			border_box.extend (box)
			border_box.extend_unexpanded (bottom_border)

			box_extend (left_border)
			box_extend_unexpanded (border_box)
			box_extend (right_border)
		end

feature -- Access

	box: EL_VERTICAL_BOX

	left_border: EV_CELL

	right_border: EV_CELL

	top_border: EV_CELL

	bottom_border: EV_CELL

	background_color: EV_COLOR
		do
			Result := box.background_color
		end

feature -- Element change

	set_background_color (a_color: like border_color)
		do
			box.set_background_color (a_color)
		end

	set_border_color (a_color: like border_color)
		do
			Precursor (a_color)
			GUI.apply_background_color (<< left_border, right_border, top_border, bottom_border, border_box >>, a_color)
		end

	set_horizontal_border_cms (a_width_cms: REAL)
		do
			across << left_border, right_border >> as border loop
				set_border_cell_width_cms (border.item, a_width_cms)
			end
		end

	set_top_border_cms (a_height_cms: REAL)
		do
			set_border_cell_height_cms (top_border, a_height_cms)
		end

	set_bottom_border_cms (a_height_cms: REAL)
		do
			set_border_cell_height_cms (bottom_border, a_height_cms)
		end

	extend (v: like item)
		do
			box.extend (v)
		end

	extend_unexpanded (v: like item)
		do
			box.extend_unexpanded (v)
		end

	append_unexpanded (a_widgets: ARRAY [EV_WIDGET])
		do
			box.append_unexpanded (a_widgets)
		end

	force_resize
		do
			prune (left_border)
			create left_border
			left_border.set_background_color (border_color)
			GUI.do_once_on_idle (agent put_front (left_border))
		end

feature -- Status change

	expand_top_border
		do
			border_box.enable_item_expand (top_border)
		end

	expand_bottom_border
		do
			border_box.enable_item_expand (bottom_border)
		end

feature {EL_BOX} -- Implementation

	set_border_cell_width_cms (a_border: EV_CELL; a_width_cms: REAL)
		do
			disable_item_expand (a_border)
			a_border.set_minimum_width (Screen.horizontal_pixels (a_width_cms))
		end

	set_border_cell_height_cms (a_border: EV_CELL; a_height_cms: REAL)
		do
			border_box.disable_item_expand (a_border)
			a_border.set_minimum_height (Screen.vertical_pixels (a_height_cms))
		end

	border_box: EL_VERTICAL_BOX
		-- box for top and bottom borders with main box in the middle

	border_cms: REAL

	padding_cms: REAL

end
