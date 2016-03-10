note
	description: "Test of dialogs."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 10:01:03 GMT (Saturday 4th January 2014)"
	revision: "3"

class
	QUANTUM_BALL_ANIMATION_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name, Installer
		end

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION2_USER_INTERFACE [QUANTUM_BALL_MAIN_WINDOW]

feature -- Desktop menu entries

	Development_menu: EL_DESKTOP_MENU_ITEM
			-- 'Development' in KDE
			-- 'Programming' in GNOME
		once
			create Result.make_standard ("Development")
		end

	Eiffel_loop_menu: EL_DESKTOP_MENU_ITEM
			--
		once
			Result := new_menu_item ("Eiffel Loop", "Eiffel Loop demo applications", Icon_path_eiffel_loop)
		end

feature {NONE} -- Desktop icon paths

	Icon_path_eiffel_loop: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "EL-logo.png" >> )
		end

	Icon_path_animation: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "animation.png" >> )
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

	Installer: EL_DESKTOP_APPLICATION_INSTALLER
			--
		once
			create Result.make (
				Current, << Development_menu, Eiffel_loop_menu >>,
				new_launcher ("Physics lesson (NO CONSOLE)", Icon_path_animation)
			)
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{QUANTUM_BALL_ANIMATION_APP}, "*"],
				[{QUANTUM_BALL_MAIN_WINDOW}, "*"],
				[{QUANTUM_BALL_ANIMATION}, "redraw, consume_product"],
				[{EL_REGULAR_INTERVAL_EVENT_PRODUCER}, "-*"],
				[{EL_THREAD_PRODUCT_QUEUE [EL_REGULAR_INTERVAL_EVENT]}, "*"]
--				[{EL_WEL_DISPLAY_MONITOR_INFO}, "*"] Windows only
			>>
		end

end
