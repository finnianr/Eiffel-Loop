note
	description: "Summary description for {EL_SCROLLABLE_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_SCROLLABLE_BOX [B -> EL_BOX create make end]

inherit
	EL_HORIZONTAL_BOX
		rename
			make as make_box,
			extend as extend_box,
			extend_unexpanded as extend_box_unexpanded,
			wipe_out as wipe_out_box
		export
			{NONE} wipe_out_box, extend_box_unexpanded, extend_box
		redefine
			set_background_color, append_unexpanded, set_focus
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_GUI
		undefine
			is_equal, copy, default_create
		end

	EV_KEY_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

feature {NONE} -- Initialization

	make (a_page_border_cms, a_page_padding_cms: REAL)
		do
			make_box (0, 0)
			create box.make (a_page_border_cms, a_page_padding_cms)

			create viewport
			viewport.put (box)

			create scroll_bar
			scroll_bar.change_actions.extend (agent on_scroll)

			extend_box (viewport)
			extend_box_unexpanded (scroll_bar)

			viewport.resize_actions.extend (agent on_viewport_resize)
			first_widget := Default_first_widget
		end

feature -- Access

	item_width: INTEGER
		do
			Result := viewport.item.width
		end

	scroll_bar_width: INTEGER
		do
			Result := scroll_bar.width
		end

feature -- Element change

	set_background_color (a_color: like background_color)
		do
			Precursor (a_color)
			viewport.set_background_color (a_color)
			box.set_background_color (a_color)
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

	wipe_out
		local
			new_box: B
		do
			create new_box.make (0, 0)
			new_box.set_padding (box.padding)
			new_box.set_border_width (box.border_width)
			new_box.set_background_color (box.background_color)
			box := new_box
			viewport.replace (box)
		end

	update_scroll_bar
		local
			hidden_page_height: INTEGER
		do
--			log.enter ("update_scroll_bar")

			hidden_page_height := viewport.item.height - viewport.height

--			log.put_integer_field ("viewport.item.height", viewport.item.height)
--			log.put_integer_field (" viewport.height", viewport.height); log.put_new_line
--			log.put_integer_field ("hidden_page_height", hidden_page_height); log.put_new_line

			if hidden_page_height > 0 then
				if not scroll_bar.is_displayed then
--					log.put_line ("Adding scrollbar")
					viewport.resize_actions.block
					scroll_bar.show
					viewport.resize_actions.resume
				end
			else
--				log.put_line ("Removing scrollbar")
				scroll_bar.hide
			end
			if scroll_bar.is_displayed then
				scroll_bar.value_range.resize_exactly (0, hidden_page_height)
				scroll_bar.set_leap ((viewport.item.height * 0.9).rounded)
				scroll_bar.set_step (Screen.vertical_pixels (1.0))
				first_widget := Default_first_widget
				set_mouse_wheel_actions; set_key_press_actions
			end
--			log.exit
		end

feature -- Status query

	has_scroll_bar: BOOLEAN
		do
			Result := has (scroll_bar)
		end

	is_scrollbar_automatic: BOOLEAN
		-- Scrollbar appears and disappears automatically on resize
		do
			Result := viewport.resize_actions.state = viewport.resize_actions.Normal_state
		end

	is_scroll_bar_visible: BOOLEAN
		do
			Result := scroll_bar.is_displayed
		end

feature -- Status setting

	enable_automatic_scrollbar
		do
			viewport.resize_actions.resume
		end

	disable_automatic_scrollbar
		do
			viewport.resize_actions.block
			scroll_bar.hide
		end

	set_focus
		do
			if first_widget /= Default_first_widget then
				GUI.do_once_on_idle (agent first_widget.set_focus)
			end
		end

feature {NONE} -- Event handlers

	on_viewport_resize (a_x, a_y, a_width, a_height: INTEGER)
		do
--			log.enter_with_args ("on_viewport_resize", << a_x, a_y, a_width, a_height >>)
			if a_width > 0 and a_height > 0 then
				update_scroll_bar
			end
--			log.exit
		end

	on_scroll (a_delta: INTEGER)
		do
			viewport.set_y_offset (((viewport.item.height - viewport.height) * scroll_bar.proportion).rounded)
		end

	on_mouse_wheel (a_delta: INTEGER)
		do
			if scroll_bar.is_displayed then
				if a_delta < 0 then
					scroll_bar.step_forward
				else
					scroll_bar.step_backward
				end
			end
		end

	on_key_press (key: EV_KEY)
		do
			if scroll_bar.is_displayed then
				inspect key.code
					when Key_page_up	 then on_key_page_up
					when Key_page_down then on_key_page_down
					when Key_home 		 then on_key_home
					when Key_end 		 then on_key_end
					when Key_up 		 then on_key_up
					when Key_down 		 then on_key_down
				else
				end
			end
		end

	on_key_page_up
		do
			scroll_bar.leap_backward
		end

	on_key_page_down
		do
			scroll_bar.leap_forward
		end

	on_key_home
		do
			scroll_bar.set_proportion (0)
		end

	on_key_end
		do
			scroll_bar.set_proportion (1.0)
		end

	on_key_up
		do
			scroll_bar.step_backward
		end

	on_key_down
		do
			scroll_bar.step_forward
		end

feature {NONE} -- Implementation

	set_mouse_wheel_actions
		do
			set_widget_actions_recursively (box, agent {EV_WIDGET_ACTION_SEQUENCES}.mouse_wheel_actions, agent on_mouse_wheel)
		end

	set_key_press_actions
		do
			set_widget_actions_recursively (box, agent {EV_WIDGET_ACTION_SEQUENCES}.key_press_actions, agent on_key_press)
		end

	set_widget_actions_recursively (
		a_widget: EV_WIDGET; action_sequence_function: FUNCTION [ANY, TUPLE, EV_ACTION_SEQUENCE [TUPLE]]
		action: PROCEDURE [ANY, TUPLE]
	)
		local
			l_child_widgets: LINEAR [EV_WIDGET]
			l_widget_actions: EV_ACTION_SEQUENCE [TUPLE]
		do
			if not attached {EV_TEXT_COMPONENT} a_widget
				and then attached {EV_WIDGET_ACTION_SEQUENCES} a_widget as l_widget_action_sequences
			then
				l_widget_actions := action_sequence_function.item ([l_widget_action_sequences])
				if l_widget_actions.is_empty then
					l_widget_actions.extend (action)
				end
			end
			if attached {EV_DYNAMIC_LIST [EV_WIDGET]} a_widget as l_list then
				l_child_widgets := l_list

			elseif attached {EV_CONTAINER} a_widget as l_container then
				l_child_widgets := l_container.linear_representation

			else -- it is not a container
				create {LINKED_LIST [EV_WIDGET]} l_child_widgets.make
				if first_widget = Default_first_widget and then not attached {EV_BUTTON} a_widget then
					-- keyboard or mouse won't work if widget is a button
					first_widget := a_widget
				end
			end
			from l_child_widgets.start until l_child_widgets.after loop
				set_widget_actions_recursively (l_child_widgets.item, action_sequence_function, action)
				l_child_widgets.forth
			end
		end

	scroll_bar: EV_VERTICAL_SCROLL_BAR

	viewport: EV_VIEWPORT

	first_widget: EV_WIDGET
		-- first widget that is not a container or a button

	box: B

feature {NONE} -- Constants

	Default_first_widget: EV_CELL
		once
			create Result
		end


end
