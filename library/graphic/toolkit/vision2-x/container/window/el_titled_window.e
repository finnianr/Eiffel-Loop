note
	description: "Titled window"
	notes: "[
		*MAKE PRECONDITION*
		
		The launcher application must conform to [$source EL_LOGGED_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-21 10:14:25 GMT (Thursday 21st April 2022)"
	revision: "10"

class
	EL_TITLED_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			implementation, create_implementation, initialize
		end

	EL_MODULE_SCREEN

	EL_MODULE_GUI

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_SHARED_THREAD_MANAGER

create
	make

feature {EL_VISION_2_USER_INTERFACE} -- Initialization

	initialize
		do
			Precursor
			create keyboard_shortcuts.make (Current)
		end

	make
		require
			logged_application: is_logged_application
		do
			default_create
			create thread_check_timer
			set_close_request_actions
--			show_actions.extend_kamikaze (agent on_initial_show)

--			GUI.do_once_on_idle (agent on_initial_show)
		end

	prepare_to_show
			--
		do
		end

feature -- Access

	keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS

feature -- Basic operations

	close_application
		do
			destroy
			ev_application.destroy
			lio.put_line ("CLOSED")
		end

	show_centered_modal (dialog: EV_DIALOG)
			--
		do
			Screen.center_in (dialog, Current, True)
			dialog.show_modal_to_window (Current)
		end

feature -- Status query

	has_wide_theme_border: BOOLEAN
		do
			Result := implementation.has_wide_theme_border
		end

feature {EL_VISION_2_USER_INTERFACE} -- Event handlers

	on_close_request
			--
		do
			log.enter ("on_close_request")
			Log_manager.redirect_main_thread_to_console
			Thread_manager.stop_all
			if Thread_manager.all_threads_stopped then
				close_application
			else
				lio.put_line ("Stopping threads ..")
				thread_check_timer.actions.extend (agent try_close_application)
				thread_check_timer.set_interval (Thread_status_update_interval_ms)
			end
			log.exit
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Implementation

	set_close_request_actions
			-- If the user clicks on the cross of `main_window', end application.
		do
			close_request_actions.extend (agent on_close_request)
		end

	set_standard_menu_bar
		do
			set_menu_bar (create {EV_MENU_BAR})
		end

feature {NONE} -- Internal attributes

	implementation: EL_TITLED_WINDOW_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	create_implementation
			-- Responsible for interaction with native graphics toolkit.
		do
			create {EL_TITLED_WINDOW_IMP} implementation.make
		end

	thread_check_timer: EV_TIMEOUT

	try_close_application
		local
			active_count: INTEGER
		do
			Thread_manager.list_active
			set_title (Active_thread_title_template #$ [Thread_manager.active_count])
			if active_count = 0 then
				thread_check_timer.set_interval (0)
				close_application
			end
		end

feature {NONE} -- Constants

	Active_thread_title_template: ZSTRING
		once
			Result := "SHUTTING DOWN (Active threads: %S)"
		end

	Thread_status_update_interval_ms: INTEGER = 200
		-- Interval between checking that all threads are stopped

end