note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_CONSOLE_MANAGER

inherit
	EL_MODULE_LOG_MANAGER

	EL_SHARED_THREAD_MANAGER
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
			--
		do
			log_manager.thread_registration_consumer.set_action (agent add_thread)
			create navigation_history.make
		end

feature {NONE} -- Basic operations

	go_history_start
			--
		do
			if not navigation_history.is_empty then
				navigation_history.start
				log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	go_history_left
			--
		do
			if not navigation_history.is_empty and then not navigation_history.isfirst then
				navigation_history.back
				log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	go_history_right
			--
		do
			if not navigation_history.is_empty and then not navigation_history.islast then
				navigation_history.forth
				log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
			end
		end

	go_history_finish
			--
		do
			if not navigation_history.is_empty then
				navigation_history.finish
				log_manager.redirect_thread_to_console (navigation_history.item)
				update_drop_down_list_selection
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
			navigation_history.extend (log_manager.console_thread_index)
			navigation_history.finish
		end

	update_drop_down_list_selection
			--
		local
			new_index: INTEGER
		do
			new_index := log_manager.console_thread_index

			if current_thread_selected /= new_index then
				current_thread_selected := new_index
				select_drop_down_list_item (new_index)
			end
		end

	select_thread (index: INTEGER)
			--
		do
			if current_thread_selected /= index then
				log_manager.redirect_thread_to_console (index)
				update_navigation_history
				current_thread_selected := index
			end
		end

	refresh_console_from_log_file
			--
		do
			log_manager.console_thread_log_file.refresh_console
		end

	select_drop_down_list_item (index: INTEGER)
			--
		deferred
		end

	add_thread (a_thread_name: STRING)
			--
		deferred
		end

feature {NONE} -- Implementation

	launch_thread_registration_consumer
			--
		do
			log_manager.thread_registration_consumer.launch
			thread_manager.extend (log_manager.thread_registration_consumer)
		end

	navigation_history: LINKED_LIST [INTEGER]

	current_thread_selected: INTEGER

end
