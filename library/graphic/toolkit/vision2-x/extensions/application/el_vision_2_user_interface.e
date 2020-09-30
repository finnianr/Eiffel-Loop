note
	description: "[
		Instance of [$source EL_APPLICATION] that creates a titled application window conforming to
		[$source EL_TITLED_WINDOW]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-25 12:27:05 GMT (Friday 25th September 2020)"
	revision: "10"

class
	EL_VISION_2_USER_INTERFACE [W -> EL_TITLED_WINDOW create make end]

inherit
	EL_VISION_2_APPLICATION
		redefine
			on_creation
		end

create
	make, make_maximized

feature {NONE} -- Initialization

	make_maximized (log_thread_management: BOOLEAN)
		do
			is_maximized := True
			make (log_thread_management)
		end

feature -- Access

	main_window: detachable W

feature -- Status query

	is_maximized: BOOLEAN

feature {NONE} -- Implementation

	close_on_exception (a_exception: EXCEPTION)
		do
			if attached {OPERATING_SYSTEM_SIGNAL_FAILURE} a_exception as os_signal_exception then
				if os_signal_exception.signal_code = 15 and then attached main_window as window then
					window.on_close_request
				end
			end
		end

	on_creation
		-- on succesful execution of `default_create' without errors
		local
			window: like main_window
		do
			create window.make
			window.prepare_to_show
			if is_maximized then
				window.maximize
			else
				window.show
			end
			main_window := window
		end

end