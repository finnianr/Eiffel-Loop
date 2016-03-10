note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 9:31:56 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_CONSOLE_MANAGER_TOOLBAR

inherit
	EL_CONSOLE_MANAGER
		rename
			make as make_console_manager
		undefine
			is_equal, copy
		end

	EL_MODULE_SCREEN
		undefine
			is_equal, copy
		end

	EL_MODULE_GUI
		export
			{NONE} all
		undefine
			is_equal, copy
		end

	EL_NAVIGATION_ICONS
		undefine
			is_equal, copy
		end

	EL_HORIZONTAL_BOX
		rename
			default_create as make_default_box,
			make as make_box
		select
			make_default_box
		end

create
	make

feature {NONE} -- Initialization

 	make (keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS; accelerator_keys_enabled: BOOLEAN)
 			--
 		local
 			label: EV_LABEL
 			label_text: STRING
 			thread_list_box: EL_VERTICAL_BOX
 		do
 			make_console_manager
			make_default_box
			if accelerator_keys_enabled then
				add_keyboard_shortcuts (keyboard_shortcuts)
			end

 			label_text := "Thread"
			create label.make_with_text (label_text)
			label.font.set_weight (GUI.Weight_bold)
			label.set_minimum_width (label.font.string_width (label_text) + 6)

 			set_padding_width (Screen.horizontal_pixels (0.2))

 			create thread_name_drop_down_list
 			thread_name_drop_down_list.select_actions.extend (agent on_selection)
 			thread_name_drop_down_list.set_tooltip ("Set thread logging output to display in console")
 			thread_name_drop_down_list.set_minimum_width (thread_name_drop_down_list.font.width * 40)

			create thread_list_box
			thread_list_box.extend (create {EV_CELL})
			thread_list_box.extend_unexpanded (thread_name_drop_down_list)
			thread_list_box.extend (create {EV_CELL})

 			extend_unexpanded (create_navigation_toolbar)

 			extend_unexpanded (label)

 			extend_unexpanded (thread_list_box)

			launch_thread_registration_consumer
 		end

feature {NONE} -- GUI component creation

	create_navigation_toolbar: EV_TOOL_BAR
			--
		do
			create Result
			Result.extend (create_tool_bar_button (Item_START_pixmap, "Switch to first thread", agent go_history_start))
			Result.extend (create_tool_bar_button (Item_PREVIOUS_pixmap, "Switch to previous thread", agent go_history_left))
			Result.extend (create_tool_bar_button (Item_NEXT_pixmap, "Switch to next thread", agent go_history_right))
			Result.extend (create_tool_bar_button (Item_END_pixmap, "Switch to end thread", agent go_history_finish))
			Result.extend (
				create_tool_bar_button (Item_REFRESH_pixmap, "Refresh console with contents of thread's log file",
				agent refresh_console_from_log_file)
			)
		end

	create_tool_bar_button (
		pixmap: EV_PIXMAP; tooltip: STRING; select_action: PROCEDURE [EL_CONSOLE_MANAGER_TOOLBAR, TUPLE]
	): EV_TOOL_BAR_BUTTON
			--
		do
			create Result
			Result.set_pixmap (pixmap)
			Result.select_actions.force_extend (select_action)
			Result.set_tooltip (tooltip)
		end

feature {NONE} -- GUI event handlers

	on_selection
			--
		do
			select_thread (thread_name_drop_down_list.index_of (thread_name_drop_down_list.selected_item, 1))
		end

feature {EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER} -- Implementation

	add_keyboard_shortcuts (keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS)
			--
		do
			keyboard_shortcuts.add_alt_key_action ({EV_KEY_CONSTANTS}.Key_left, agent go_history_left)
			keyboard_shortcuts.add_alt_key_action ({EV_KEY_CONSTANTS}.Key_right, agent go_history_right)
		end

	add_thread (a_thread_name: STRING)
			--
		local
			position: INTEGER
			list_item: EV_LIST_ITEM
		do
			position := thread_name_drop_down_list.count + 1
			create list_item.make_with_text (position.out + ". " + a_thread_name)
			thread_name_drop_down_list.extend (list_item)

--			name_width := thread_name_drop_down_list.font.string_width (list_item.text)
 			thread_name_drop_down_list.set_minimum_width_in_characters (list_item.text.count + 3)

		end

	select_drop_down_list_item (an_index: INTEGER)
			--
		do
			thread_name_drop_down_list.select_item (an_index)
		end

	thread_name_drop_down_list: EL_COMBO_BOX

end
