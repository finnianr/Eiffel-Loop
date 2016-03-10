note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:14:43 GMT (Monday 24th June 2013)"
	revision: "2"

class
	QUANTUM_BALL_MAIN_WINDOW

inherit
	EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER
		redefine
			 initialize, prepare_to_show
		end

	EL_MODULE_LOG
		undefine
			copy , default_create
		end

	EL_MODULE_ICON
		undefine
			copy , default_create
		end

	EL_THREAD_DEVELOPER_CLASS
		undefine
			copy , default_create
		end

create
	make

feature {NONE} -- Initialization

	initialize
   			--
		do
			Precursor
			set_title (Window_title)
			set_icon_pixmap (Icon_window)
			set_border_width (Border_width)
			set_border_color (GUI.Black)

			create ball_animation.make
			add_toolbar_buttons
		end


feature {NONE} -- Event handler

	on_show
			--
		do
		end

feature {NONE} -- Create UI

	prepare_to_show
			--
		do
			set_maximum_width (width)
			extend (ball_animation.model_cell)
		end

	add_toolbar_buttons
			--
		local
			button: EV_BUTTON
		do
			if tool_bar.is_empty then
				tool_bar.extend (create {EV_CELL})
			else
				tool_bar.extend_unexpanded (vertical_separator (Screen.horizontal_pixels (0.2)))
			end

			create button.make_with_text ("START")
			tool_bar.extend_unexpanded (button)
			button.select_actions.extend (agent ball_animation.start)
			Previous_call_is_thread_signal
				-- not really, actual call comes from main thread in response to user clicking button
-- THREAD SIGNAL


			create button.make_with_text ("STOP")
			tool_bar.extend_unexpanded (button)
			button.select_actions.extend (agent ball_animation.stop)

			tool_bar.extend (create {EV_CELL})
		end

feature {NONE} -- Implementation

	ball_animation: QUANTUM_BALL_ANIMATION

feature {NONE} -- Constants

	Window_title: STRING = "Physics lesson (I)"
			-- Title of the window.

	Icon_window: EV_PIXMAP
			--
		once
			Result := Icon.pixmap (<< "hydrogen.png" >>)
		end

	Border_width: INTEGER
			--
		once
			Result := Screen.horizontal_pixels (1.2)
		end

end
