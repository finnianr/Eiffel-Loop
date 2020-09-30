note
	description: "[
		Vision-2 GUI application with support for the following 
		
		* Positioning of Windows that takes into account usable area, i.e. total area less the system toolbar
		* management of multi-threaded logging output in terminal console
		* Execution of events sent to shared instance of [$source EL_MAIN_THREAD_EVENT_REQUEST_QUEUE] by main GUI thread.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-24 12:52:03 GMT (Thursday 24th September 2020)"
	revision: "1"

class
	EL_VISION_2_APPLICATION

inherit
	EV_APPLICATION
		redefine
			create_implementation, create_interface_objects, initialize
		end

	EL_MODULE_SCREEN

	EL_MODULE_PIXMAP

	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

create
	make

feature {NONE} -- Initialization

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

feature {NONE} -- Initialization

	make (log_thread_management: BOOLEAN)
			--
		local
			dialog: EV_INFORMATION_DIALOG; shared_manager: EL_THREAD_MANAGER
		do
			-- create shared thread manager
			if log_thread_management then
				create {EL_LOGGED_THREAD_MANAGER} shared_manager
			else
				create shared_manager
			end
			create error_message.make_empty
			default_create

			if error_message.is_empty then
				on_creation
			else
				-- Error dialog
				create dialog.make_with_text_and_actions (error_message , << agent destroy >>)
				dialog.set_title ("Application Initialization Error")
				dialog.set_pixmap (Pixmap.Error_pixmap)
				dialog.set_icon_pixmap (Pixmap.Error_pixmap)
				dialog.show
			end
		end

feature -- Access

	error_message: STRING

feature -- Element change

	set_error_message (a_error_message: STRING)
		do
			error_message := a_error_message
		end

feature {NONE} -- Implementation

	create_implementation
		local
			new_queue: EL_VISION_2_MAIN_THREAD_EVENT_REQUEST_QUEUE
		do
			Precursor
			if attached {EL_APPLICATION_I} implementation as l_implementation then
				create new_queue.make (l_implementation.event_emitter)
				set_main_thread_event_request_queue (new_queue)
			end
		end

	create_interface_objects
		local
			useable_screen: EL_USEABLE_SCREEN_IMP
		do
			-- For Unix systems this shared object has to be created before any Vision-2 GUI code
			-- It calls code that is effectively a mini GTK app to determine the useable screen space
			create useable_screen.make
		end

	on_creation
		-- on succesful execution of `default_create' without errors
		do
		end
end