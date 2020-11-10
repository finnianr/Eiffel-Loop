note
	description: "[
		Application to demonstrate multi-threaded console output switching.
		One thread produces timer events and another consumes them. Use the console toolbar to
		switch log output that is visible in terminal console.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:16:32 GMT (Tuesday 10th November 2020)"
	revision: "6"

class
	QUANTUM_BALL_ANIMATION_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_INSTALLABLE_SUB_APPLICATION
		redefine
			name
		end

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (True)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION_2_USER_INTERFACE [QUANTUM_BALL_MAIN_WINDOW]

feature {NONE} -- Install constants

	Name: ZSTRING
		once
			Result := "Physics lesson (NO CONSOLE)"
		end

	desktop_launcher: EL_DESKTOP_MENU_ITEM
		do
			Result := new_launcher ("animation.png")
		end

	desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		do
			Result := <<
				new_category ("Development"),
				new_custom_category ("Eiffel Loop", "Eiffel Loop demo applications", "EL-logo.png")
			>>
		end

	Desktop: EL_DESKTOP_ENVIRONMENT_I
			--
		once
			Result := new_menu_desktop_environment
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER,
		QUANTUM_BALL_MAIN_WINDOW,
		QUANTUM_BALL_ANIMATION
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "animation"
		end

	Description: STRING
		once
			Result := "Animation of hydrogen atom as timer thread test"
		end

end