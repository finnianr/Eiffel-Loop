note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_CONSOLE_MANAGER_DIALOG

inherit
	EL_DIALOG
		undefine
			on_sys_key_down
		redefine
			on_control_id_command, notify
		end

	EL_ALT_ARROW_KEY_CAPTURE

	EL_CONSOLE_MANAGER
		rename
			make as make_console_manager
		end

feature {NONE} -- Initialization

	make_child (a_parent: WEL_WINDOW; a_name: STRING)
			--
		do
			make_child_dialog (a_parent, a_name, 670, 80)
			make_console_manager

			move (0, 0)

			add_history_buttons

			layout_pos.set_x (client_rect.width - Log_refresh_button_width - border_left_right)
			layout_size.set_width (Log_refresh_button_width)
			create log_refresh_button.make (
				Current, "Refresh", layout_pos, layout_size, Id_console_thread_refresh_button
			)
			add_control (log_refresh_button)

			add_thread_name_drop_down

			launch_thread_registration_consumer
		end

feature -- Event handlers

	on_pending_edit
			-- A new edit has been added to the pending list
		do
		end

	on_pending_edits_applied
			-- All pending edits have been applied
		do
		end

	on_control_id_command  (control_id: INTEGER)
			--	
		do
			if control_id = ID_console_thread_start_button then
				go_history_start

			elseif control_id = ID_console_thread_left_button then
				go_history_left

			elseif control_id = ID_console_thread_right_button then
				go_history_right

			elseif control_id = ID_console_thread_finish_button then
				go_history_finish

			elseif control_id = ID_console_thread_refresh_button then
				log_manager.console_thread_log_file.refresh_console

			end
		end

	on_alt_left_arrow_key_down
			--
		do
			go_history_left
		end

	on_alt_right_arrow_key_down
			--
		do
			go_history_right
		end

feature {NONE} -- Component layout

	add_history_buttons
			--
		do
			layout_size.set_width (button_width)
			layout_size.set_height (Button_height)

			create history_start_button.make (
				Current, "|<", layout_pos, layout_size, id_console_thread_start_button
			)
			add_control (history_start_button)
			layout_next_control

			create history_left_button.make (
				Current, "<<", layout_pos, layout_size, id_console_thread_left_button
			)
			add_control (history_left_button)
			layout_next_control

			create history_right_button.make (
				Current, ">>", layout_pos, layout_size, id_console_thread_right_button
			)
			add_control (history_right_button)
			layout_next_control

			create history_finish_button.make (
				Current, ">|", layout_pos, layout_size, id_console_thread_finish_button
			)
			add_control (history_finish_button)
			layout_next_control

		end

	add_thread_name_drop_down
			--
		do
			layout_pos.set_x (history_finish_button.x)
			layout_size.set_width (history_finish_button.width)
			layout_next_control

			layout_size.set_width (60)
			layout_size.set_height ((Button_height * 1.5).rounded)

			add_label ("Thread")
			layout_next_control

			layout_pos.set_y (layout_pos.y - 4)
			layout_size.set_width (log_refresh_button.x - layout_pos.x - Field_spacing)
			layout_size.set_height (Button_height * 7)

			create thread_name_drop_down_list.make (Current, layout_pos, layout_size)
			add_control (thread_name_drop_down_list)
			layout_pos.set_y (layout_pos.y + 4)
		end

	select_drop_down_list_item (index: INTEGER)
			--
		do
			thread_name_drop_down_list.select_item (index - 1)
		end

	add_thread (a_thread_name: STRING)
			--
		local
			position: INTEGER
		do
			position := thread_name_drop_down_list.count + 1
			thread_name_drop_down_list.add_string (position.out + ". " + a_thread_name)

			if not thread_name_drop_down_list.selected then
				thread_name_drop_down_list.select_item (0)
				current_thread_selected := 1
				navigation_history.extend (1)
				navigation_history.start
				log_manager.console_thread_log_file.refresh_console
			end
		end

feature {NONE} -- Implementation

	notify (control: WEL_CONTROL; notify_code: INTEGER)
			--
		do
			if control = thread_name_drop_down_list then
				if thread_name_drop_down_list.selected then
					select_thread (thread_name_drop_down_list.selected_item + 1)
				end
			end
		end

	thread_name_drop_down_list: EL_THREAD_NAME_DROP_DOWN_LIST

	history_left_button: EL_CONSOLE_HISTORY_NAVIGATION_BUTTON

	history_right_button: EL_CONSOLE_HISTORY_NAVIGATION_BUTTON

	history_start_button: EL_CONSOLE_HISTORY_NAVIGATION_BUTTON

	history_finish_button: EL_CONSOLE_HISTORY_NAVIGATION_BUTTON

	log_refresh_button: EL_CONSOLE_HISTORY_NAVIGATION_BUTTON

feature {NONE} -- Default constants

	Log_refresh_button_width: INTEGER = 80

	Button_width: INTEGER = 24

	Button_height: INTEGER = 24

	Field_spacing: INTEGER = 10

	Border_left_right: INTEGER = 10

	Border_top_bottom: INTEGER = 15

	Id_console_thread_left_button: INTEGER
			--
		deferred
		end

	Id_console_thread_right_button: INTEGER
			--
		deferred
		end

	Id_console_thread_start_button: INTEGER
			--
		deferred
		end

	Id_console_thread_finish_button: INTEGER
			--
		deferred
		end

	Id_console_thread_refresh_button: INTEGER
			--
		deferred
		end

end
