note
	description: "Remote routine call server main window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EROS_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER
		undefine
			pixmaps
		redefine
			 initialize, prepare_to_show
		end

	EROS_UI_CONSTANTS

	EV_FRAME_CONSTANTS undefine copy, default_create end

	EL_SHARED_THREAD_MANAGER

	EL_MODULE_LOG

	EROS_SHARED_PIXMAPS

create
	make

feature {NONE} -- Initialization

	initialize
   			-- Mark `Current' as initialized.
   			-- This must be called during the creation procedure
   			-- to satisfy the `is_initialized' invariant.
   			-- Descendants may redefine initialize to perform
   			-- additional setup tasks.
		do
			Precursor
			add_toolbar_components
		end

feature {EV_APPLICATION} -- Initialization

	prepare_to_show
			--
   		local
   			l_box: EV_VERTICAL_BOX
		do
			create l_box
			l_box.set_border_width (10)
			l_box.set_padding (5)
			l_box.extend (activity_meters.widget)
			extend (l_box)

			ev_application.do_once_on_idle (agent activity_meters.reset)
			ev_application.do_once_on_idle (agent disable_user_resize)
		end

feature -- Element change

	set_connection_manager (port_number, request_handler_count_max: INTEGER)
			--
		do
			create activity_meters.make (request_handler_count_max)
			create connection_manager_thread.make (port_number, request_handler_count_max, activity_meters.service_stats)
			thread_manager.extend (connection_manager_thread)
		end

feature {NONE} -- Event handler

	on_show
			--
		do
			on_off_lights.set_off
		end

	on_go_click
			--
		do
			if go_button.is_selected then
				connection_manager_thread.launch
				on_off_lights.set_on
				activity_meters.reset
			else
				connection_manager_thread.stop
				on_off_lights.set_off
			end
		end

feature {NONE} -- Build UI

	add_toolbar_components
			--
		local
			lights_frame: EV_FRAME
		do
			create go_button.make_with_text ("GO")
			create on_off_lights.make (Pixmaps.green_light, Pixmaps.red_light, Pixmaps.unlit_light, 3)

			if tool_bar.is_empty then
				tool_bar.extend (create {EV_CELL})
			else
				tool_bar.extend_unexpanded (vertical_separator (Screen.horizontal_pixels (0.2)))
			end

			tool_bar.extend_unexpanded (go_button)
			go_button.select_actions.extend (agent on_go_click)

			create lights_frame
			lights_frame.set_style (Frame_style.ev_frame_raised)
			lights_frame.extend (on_off_lights)
			tool_bar.extend_unexpanded (lights_frame)
			tool_bar.extend (create {EV_CELL})

		end

feature {NONE} -- Implementation

	connection_manager_thread: EROS_CALL_REQUEST_CONNECTION_MANAGER_THREAD

	go_button: EV_TOGGLE_BUTTON

	on_off_lights: EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA

	activity_meters: EROS_SERVER_ACTIVITY_METERS

end