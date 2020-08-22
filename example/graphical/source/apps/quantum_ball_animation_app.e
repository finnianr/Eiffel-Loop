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
	date: "2020-08-21 15:26:58 GMT (Friday 21st August 2020)"
	revision: "4"

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

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "animation"
		end

	Description: STRING
		once
			Result := "Animation of hydrogen atom as timer thread test"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{QUANTUM_BALL_ANIMATION_APP}, All_routines],
				[{QUANTUM_BALL_MAIN_WINDOW}, All_routines],
				[{QUANTUM_BALL_ANIMATION}, All_routines],
				[{EL_LOGGED_REGULAR_INTERVAL_EVENT_PRODUCER}, All_routines]
--				[{EL_THREAD_PRODUCT_QUEUE [EL_REGULAR_INTERVAL_EVENT]}, All_routines]
--				[{EL_WEL_DISPLAY_MONITOR_INFO}, All_routines] Windows only
			>>
		end

end
