note
	description: "[
		Toolbar for switching the console logged output to a different thread.
		
		**Features**
		
		* Thread contexts are selectable from a dialog drop down list
		* Thread selection history navigation buttons with browser style ALT left/right arrow keyboard shortcuts
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_CONSOLE_MANAGER_TOOLBAR

inherit
	EL_CONSOLE_MANAGER
		rename
			make as make_console_manager
		undefine
			is_equal, copy
		end

	EL_NAVIGATION_ICONS

	EL_HORIZONTAL_BOX
		rename
			default_create as make_default_box,
			make as make_box
		select
			make_default_box
		end

	EL_MODULE_SCREEN

	EL_MODULE_TEXT

create
	make

feature {NONE} -- Initialization

 	make (keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS; accelerator_keys_enabled: BOOLEAN)
 			--
 		local
 			label: EV_LABEL; label_text: STRING; thread_list_box: EL_VERTICAL_BOX
 		do
 			make_console_manager
			make_default_box
			if accelerator_keys_enabled then
				add_keyboard_shortcuts (keyboard_shortcuts)
			end

 			label_text := "Thread"
			create label.make_with_text (label_text)
			label.font.set_weight (Text.Weight_bold)
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

 			extend_unexpanded (new_navigation_toolbar)

 			extend_unexpanded (label)

 			extend (thread_list_box)

			launch_thread_registration_consumer
 		end

feature {NONE} -- GUI component creation

	new_navigation_toolbar: EV_TOOL_BAR
			--
		local
			name, description: ZSTRING
		do
			create Result
			Action_table.set_targets (Current)
			across item_pixmap_list as list loop
				name := list.item.name
				if name ~ Refresh then
					description := "Refresh console with contents of thread's log file"
				else
					description := Switch_template #$ [name]
				end
				Result.extend (new_tool_bar_button (list.item, description, Action_table [name]))
			end
		end

	new_tool_bar_button (pixmap: EV_PIXMAP; tooltip: ZSTRING; select_action: PROCEDURE): EV_TOOL_BAR_BUTTON
			--
		do
			create Result
			Result.set_pixmap (pixmap)
			Result.select_actions.force_extend (select_action)
			Result.set_tooltip (tooltip.to_unicode)
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
			keyboard_shortcuts.add_alt_key_action ({EV_KEY_CONSTANTS}.Key_left, agent go_history_previous)
			keyboard_shortcuts.add_alt_key_action ({EV_KEY_CONSTANTS}.Key_right, agent go_history_next)
		end

	add_thread (a_thread: EL_IDENTIFIED_THREAD_I)
			--
		local
			position: INTEGER; list_item: EV_LIST_ITEM
		do
			position := thread_name_drop_down_list.count + 1
			create list_item.make_with_text (Name_template #$ [position, a_thread.name])
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

feature {NONE} -- Constants

	Action_table: EL_PROCEDURE_TABLE [ZSTRING]
		once
			create Result.make (<<
				["start", agent go_history_start],
				["previous", agent go_history_previous],
				["next", agent go_history_next],
				["last", agent go_history_last],
				["refresh", agent refresh_console_from_log_file]
			>>)
		end

	Name_template: ZSTRING
		once
			Result := "%S. %S"
		end

	Refresh: STRING = "refresh"

	Switch_template: ZSTRING
		once
			Result := "Switch to %S thread"
		end

end