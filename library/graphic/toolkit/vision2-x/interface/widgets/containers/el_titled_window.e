note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:18:30 GMT (Friday 8th July 2016)"
	revision: "5"

class
	EL_TITLED_WINDOW

inherit
	EV_TITLED_WINDOW
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position
		redefine
			implementation, create_implementation, initialize
		end

	EL_WINDOW
		undefine
			copy, default_create
		end

	EL_MODULE_SCREEN
		undefine
			copy, default_create
		end

	EL_MODULE_GUI
		undefine
			copy, default_create
		end

	EL_MODULE_LOG
		undefine
			copy, default_create
		end

	EL_MODULE_LOG_MANAGER
		undefine
			copy, default_create
		end

	EL_SHARED_THREAD_MANAGER
		undefine
			copy, default_create
		end

create
	make

feature {EL_VISION2_USER_INTERFACE} -- Initialization

	make
		do
			default_create
			create thread_check_timer
			set_close_request_actions
--			show_actions.extend_kamikaze (agent on_initial_show)

--			GUI.do_once_on_idle (agent on_initial_show)
		end

	initialize
		do
			Precursor
			create keyboard_shortcuts.make (Current)
		end

	prepare_to_show
			--
		do
		end

feature -- Access

	keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS

feature -- Basic operations

	show_centered_modal (dialog: EV_DIALOG)
			--
		do
			position_window_center (dialog)
			dialog.show_modal_to_window (Current)
		end

feature -- Status query

	has_wide_theme_border: BOOLEAN
		do
			Result := implementation.has_wide_theme_border
		end

feature {EL_VISION2_USER_INTERFACE} -- Event handlers

	on_close_request
			--
		do
			log.enter ("on_close_request")
			log_manager.redirect_main_thread_to_console
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

	implementation: EL_TITLED_WINDOW_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

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

	close_application
		do
			destroy
			ev_application.destroy
			lio.put_line ("CLOSED")
		end

	thread_check_timer: EV_TIMEOUT

	create_implementation
			-- Responsible for interaction with native graphics toolkit.
		do
			create {EL_TITLED_WINDOW_IMP} implementation.make
		end

feature {NONE} -- Constants

	Thread_status_update_interval_ms: INTEGER = 200
		-- Interval between checking that all threads are stopped

	Active_thread_title_template: ZSTRING
		once
			Result := "SHUTTING DOWN (Active threads: %S)"
		end

end