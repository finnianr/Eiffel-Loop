note
	description: "[
		Vision2 GUI supporting management of multi-threaded logging output
		in terminal console
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 20:30:20 GMT (Monday 12th March 2018)"
	revision: "3"

class
	EL_VISION2_USER_INTERFACE [W -> EL_TITLED_WINDOW create make end]

inherit
	EV_APPLICATION
		redefine
			create_implementation, create_interface_objects, initialize
		end

	EL_MODULE_LOG
		undefine
			copy, default_create
		end

	EL_SHARED_LOGGED_THREAD_MANAGER
		undefine
			copy, default_create
		end

	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE
		undefine
			copy, default_create
		end

	EL_SHARED_USEABLE_SCREEN
		undefine
			copy, default_create
		end

	EV_BUILDER

	EL_MODULE_SCREEN
		undefine
			copy, default_create
		end

create
	make, make_maximized

feature {NONE} -- Initialization

	make_maximized (log_thread_management: BOOLEAN)
		do
			is_maximized := True
			make (log_thread_management)
		end

	make (log_thread_management: BOOLEAN)
			--
		local
			error_dialog: EV_INFORMATION_DIALOG; pixmaps: EV_STOCK_PIXMAPS
		do
			call (Thread_manager)
			log.enter ("make")
			create error_message.make_empty
			default_create

			if error_message.is_empty then
				main_window := new_window
				prepare_to_show
				if is_maximized then
					main_window.maximize
				else
					main_window.show
				end
			else
				create error_dialog.make_with_text_and_actions (error_message , << agent destroy >>)
				create pixmaps
				error_dialog.set_title ("Application Initialization Error")
				error_dialog.set_pixmap (pixmaps.Error_pixmap)
				error_dialog.set_icon_pixmap (pixmaps.Error_pixmap)
				error_dialog.show
			end
			log.exit
		end

	initialize
			--
		local
			display_size: EL_ADJUSTED_DISPLAY_SIZE
		do
			Precursor
			create display_size.make
			display_size.read
			Screen.set_dimensions (display_size.width_cms, display_size.height_cms)
		end

feature -- Access

	main_window: W

	error_message: STRING

feature -- Element change

	set_error_message (a_error_message: STRING)
		do
			error_message := a_error_message
		end

feature {NONE} -- Status query

	is_maximized: BOOLEAN

	is_thread_management_logged: BOOLEAN

feature {NONE} -- Implementation

	call (object: ANY)
			-- For initializing once routines
		do
		end

	new_window: like main_window
		do
			create Result.make
		end

	create_interface_objects
		do
			-- For Unix systems this has to be called before any Vision2 GUI code
			-- It calls code that is effectively a mini GTK app to determine the useable screen space
			call (Useable_screen)
		end

	prepare_to_show
			--
		do
			main_window.prepare_to_show
		end

	close_on_exception (a_exception: EXCEPTION)
		do
			if attached {OPERATING_SYSTEM_SIGNAL_FAILURE} a_exception as os_signal_exception then
				if os_signal_exception.signal_code = 15 then
					main_window.on_close_request
				end
			end
		end

	create_implementation
		do
			Precursor
			if attached {EL_APPLICATION_I} implementation as l_implementation then
				set_main_thread_event_request_queue (
					create {EL_VISION2_MAIN_THREAD_EVENT_REQUEST_QUEUE}.make (l_implementation.event_emitter)
				)
			end
		end

end
