note
	description: "Widget and menu-item routines accessible via [$source EL_MODULE_WIDGET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-24 18:30:49 GMT (Wednesday 24th February 2021)"
	revision: "5"

frozen class
	EL_WIDGET_ROUTINES

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_GUI

	EL_MODULE_ORIENTATION

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

feature {NONE} -- Initialization

	default_create
			--
		do
			busy_widget := Default_busy_widget
		end

feature -- Access

	box_widget_list (container: EV_CONTAINER): ARRAYED_LIST [EV_WIDGET]
		-- list of all box widgets recursively contained in `container'
		do
			create Result.make (20)
			fill_box_widget_list (container, Result)
		end

	parent_window (widget: EV_WIDGET): EV_WINDOW
		do
			if attached {EV_WINDOW} widget as window then
				Result := window
			else
				Result := parent_window (widget.parent)
			end
		end

feature -- Basic operations

	fill_box_widget_list (container: EV_CONTAINER; a_list: ARRAYED_LIST [EV_WIDGET])
		-- recursively fill `a_list' with all box widgets contained in `container'
		local
			list: LINEAR [EV_WIDGET]
		do
			if attached {EV_BOX} container as box then
				across box as widget loop
					a_list.extend (widget.item)
				end
			end
			list := container.linear_representation
			from list.start until list.after loop
				if attached {EV_CONTAINER} list.item as sub_container then
					fill_box_widget_list (sub_container, a_list)
				end
				list.forth
			end
		end

	insert_at (list: EV_DYNAMIC_LIST [EV_CONTAINABLE]; item: EV_ITEM; position: INTEGER)
		-- insert `item' into `list' at `position' or at the end if `position = 0'
		local
			index: INTEGER
		do
			if position > 0 and then list.valid_index (position - 1) then
				index := list.index
				list.go_i_th (position - 1)
				list.put_right (item)
				if list.valid_index (index) then
					list.go_i_th (index)
				end
			else
				list.extend (item)
			end
		end

	propagate_background_color (a_container: EV_CONTAINER; background_color: EV_COLOR; is_excluded: PREDICATE [EV_WIDGET])
			-- Propagate background
		do
			if not is_excluded (a_container) then
				a_container.set_background_color (background_color)
				if attached a_container.linear_representation as list then
					from list.start until list.after loop
						if attached {EV_CONTAINER} list.item as container then
							propagate_background_color (container, background_color, is_excluded)
						elseif not is_excluded (list.item) then
							list.item.set_background_color (background_color)
						end
						list.forth
					end
				end
			end
		end

	refresh (a_widget: EV_WIDGET)
		do
			a_widget.refresh_now
			GUI.application.process_graphical_events
		end

	replace (widget, new_widget: EV_WIDGET)
		-- replace `item' in `widget.parent' with `new_widget'
		local
			is_expanded: BOOLEAN
		do
			if attached {EV_CONTAINER} widget.parent as container then
				if attached {EV_WIDGET_LIST} container as list then
					list.start; list.search (widget)
					if not list.exhausted then
						if attached {EV_BOX} list as box then
							is_expanded := box.is_item_expanded (widget)
							box.replace (new_widget)
							if is_expanded then
								box.enable_item_expand (box.item)
							else
								box.disable_item_expand (box.item)
							end
						else
							list.replace (new_widget)
						end
					end
				else
					container.replace (new_widget)
				end
			end
		end

	replace_item (item, new_item: EV_ITEM)
		do
			if attached {EV_DYNAMIC_LIST [EV_CONTAINABLE]} item.parent as list then
				list.start; list.search (item)
				if not list.exhausted then
					list.replace (new_item)
				end
			end
		end

feature -- Status change

	enable_all_sensitive_if (item_list: ARRAY [EV_SENSITIVE]; condition_true: BOOLEAN)
		do
			item_list.do_all (agent enable_sensitive_if (?, condition_true))
		end

	enable_sensitive_if (widget: EV_SENSITIVE; condition_true: BOOLEAN)
		do
			if condition_true then
				widget.enable_sensitive
			else
				widget.disable_sensitive
			end
		end

	set_selection (widget: EV_SELECTABLE; is_selected: BOOLEAN)
		-- set selection status on selectable `widget' without triggering actions
		require
			has_select_actions: attached {EV_BUTTON_ACTION_SEQUENCES} widget or attached {EV_MENU_ITEM_ACTION_SEQUENCES} widget
		local
			select_actions: EV_NOTIFY_ACTION_SEQUENCE
		do
			if attached {EV_BUTTON_ACTION_SEQUENCES} widget as action_sequences then
				select_actions := action_sequences.select_actions

			elseif attached {EV_MENU_ITEM_ACTION_SEQUENCES} widget as action_sequences then
				select_actions := action_sequences.select_actions

			end
			select_actions.block
			if attached {EV_SELECTABLE} widget as selectable_button and then is_selected then
				selectable_button.enable_select

			elseif attached {EV_DESELECTABLE} widget as deselectable_button and then not is_selected then
				deselectable_button.disable_select
			end
			select_actions.resume
		end

	set_text_field_characteristics (field: EV_TEXT_FIELD; capacity: INTEGER; a_font: EV_FONT)
			--
		do
			field.set_font (a_font)
			field.set_minimum_width_in_characters (capacity)
		end

feature -- Apply styling

	apply_bold (font: EV_FONT)
		do
			font.set_weight (GUI.Weight_bold)
		end

	apply_colors (widget_list: ARRAY [EV_COLORIZABLE]; foreground_color, background_color: detachable EV_COLOR)
			--
		do
			across widget_list as widget loop
				if attached foreground_color as foreground then
					widget.item.set_foreground_color (foreground)
				end
				if attached background_color as background then
					widget.item.set_background_color (background)
				end
			end
		end

feature -- Mouse pointer setting

	restore_standard_pointer
		do
			if busy_widget /= Default_busy_widget then
				busy_widget.set_pointer_style (Pixmap.Standard_cursor)
				busy_widget := Default_busy_widget
			end
		end

	set_busy_pointer (widget: EV_WIDGET; relative_position: INTEGER)
		require
			valid_position: Orientation.is_valid_position (relative_position)
		local
			coord: EL_INTEGER_COORDINATE; rectangle: EL_RECTANGLE
		do
			create rectangle.make_for_widget (widget)
			coord := rectangle.edge_coordinate (relative_position)
			set_busy_pointer_at_position (widget, coord.x, coord.y)
		end

	set_busy_pointer_at (widget: EV_WIDGET; position_x_cms, position_y_cms: REAL)
		do
			set_busy_pointer_at_position (
				widget, Screen.horizontal_pixels (position_x_cms), Screen.vertical_pixels (position_y_cms)
			)
		end

	set_busy_pointer_at_position (widget: EV_WIDGET; position_x, position_y: INTEGER)
		local
			x, y: INTEGER; cursor: like Pixmap.Busy_cursor
		do
			cursor := Pixmap.Busy_cursor
			x := position_x; y := position_y
			if x = 0 then
				x := cursor.x_hotspot - cursor.width
			else
				x := x + cursor.x_hotspot
			end
			if y = 0 then
				y := cursor.y_hotspot - cursor.height
			else
				y := y + cursor.y_hotspot
			end
			Screen.set_pointer_position (widget.screen_x + x, widget.screen_y  + y)
			from busy_widget := widget until attached {EV_CONTAINER} busy_widget loop
				busy_widget := busy_widget.parent
			end
			busy_widget.set_pointer_style (cursor)
		end

	set_busy_pointer_for_action (action: PROCEDURE; widget: EV_WIDGET; position: INTEGER)
		do
			set_busy_pointer (widget, position)
			GUI.do_once_on_idle (action)
			GUI.do_once_on_idle (agent restore_standard_pointer)
		end

	set_busy_pointer_for_action_at (action: PROCEDURE; widget: EV_WIDGET; position_x_cms, position_y_cms: REAL)
		do
			set_busy_pointer_at (widget, position_x_cms, position_y_cms)
			GUI.do_once_on_idle (action)
			GUI.do_once_on_idle (agent restore_standard_pointer)
		end

	set_busy_pointer_for_duration (widget: EV_WIDGET; position, duration_seconds: INTEGER)
		do
			set_busy_pointer (widget, position)
			GUI.do_later (duration_seconds * 1000, agent restore_standard_pointer)
		end

feature {NONE} -- Internal attributes

	busy_widget: EV_WIDGET

feature {NONE} -- Constants

	Default_busy_widget: EV_WIDGET
		once
			create {EV_CELL} Result
		end

end