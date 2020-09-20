note
	description: "Console manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-20 10:19:07 GMT (Sunday 20th September 2020)"
	revision: "6"

deferred class
	EL_CONSOLE_MANAGER

inherit
	ANY

	EL_MODULE_LOG_MANAGER

	EL_SHARED_THREAD_MANAGER

feature {NONE} -- Initialization

	make
			--
		do
			Log_manager.thread_registration_consumer.set_action (agent add_thread)
			create navigation_history.make
		end

feature {NONE} -- Basic operations

	add_thread (a_thread: EL_IDENTIFIED_THREAD_I)
			--
		deferred
		end

	go_history_last
			--
		do
			if not navigation_history.is_empty then
				navigation_history.finish
				Log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	go_history_previous
			--
		do
			if not navigation_history.is_empty and then not navigation_history.isfirst then
				navigation_history.back
				Log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	go_history_next
			--
		do
			if not navigation_history.is_empty and then not navigation_history.islast then
				navigation_history.forth
				Log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	go_history_start
			--
		do
			if not navigation_history.is_empty then
				navigation_history.start
				Log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	refresh_console_from_log_file
			--
		do
			Log_manager.console_thread_log_file.refresh_console
		end

	select_drop_down_list_item (index: INTEGER)
			--
		deferred
		end

	select_thread (index: INTEGER)
			--
		do
			if current_thread_selected /= index then
				Log_manager.redirect_thread_to_console (index)
				update_navigation_history
				current_thread_selected := index
			end
		end

	update_drop_down_list_selection
			--
		local
			new_index: INTEGER
		do
			new_index := Log_manager.console_thread_index

			if current_thread_selected /= new_index then
				current_thread_selected := new_index
				select_drop_down_list_item (new_index)
			end
		end

	update_navigation_history
			--
		do
			if not navigation_history.islast then
				from navigation_history.forth until navigation_history.after
				loop
					navigation_history.remove
				end
			end
			navigation_history.extend (Log_manager.console_thread_index)
			navigation_history.finish
		end

feature {NONE} -- Implementation

	launch_thread_registration_consumer
			--
		do
			Log_manager.thread_registration_consumer.launch
			thread_manager.extend (Log_manager.thread_registration_consumer)
		end

feature {NONE} -- Internal attributes

	current_thread_selected: INTEGER

	navigation_history: LINKED_LIST [INTEGER]

end