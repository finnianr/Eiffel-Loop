note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-09 7:45:31 GMT (Thursday 9th July 2015)"
	revision: "4"

deferred class
	EL_TITLED_WINDOW_WITH_CONSOLE_MANAGER

inherit
	EL_TITLED_WINDOW
		rename
			extend as window_extend
		redefine
			initialize
		end

	EV_SHARED_APPLICATION
		undefine
			copy, default_create
		end

	EL_MODULE_GUI
		undefine
			copy, default_create
		end

feature {NONE} -- Initialization

	initialize
			--
		local
			window_box: EL_VERTICAL_BOX
			tool_bar_frame: EV_FRAME
		do
			Precursor

			create window_box
			window_box.set_border_cms (window_border_cms)
			window_box.set_padding_cms (Window_padding_cms)

			create tool_bar
			tool_bar.set_border_width (Toolbar_border_width)
			tool_bar.set_padding (Toolbar_padding_width)

			if has_toolbar then
				create tool_bar_frame
				tool_bar_frame.set_style ({EV_FRAME_CONSTANTS}.Ev_frame_raised)
				tool_bar_frame.extend (tool_bar)
				if has_console_manager then
					tool_bar.extend_unexpanded (
						create {EL_CONSOLE_MANAGER_TOOLBAR}.make (keyboard_shortcuts, console_accelerator_keys_enabled)
					)
				end
				upper_bar.extend (tool_bar_frame)
				upper_bar.set_border_width (Screen.horizontal_pixels (window_border_cms))
			end

			create component_box
			window_box.extend (component_box)

			window_extend (window_box)

		end

feature -- Element change

	set_border_color (a_color: EV_COLOR)
			--
		do
			component_box.set_background_color (a_color)
		end

	set_border_width (value: INTEGER)
			--
		do
			component_box.set_border_width (value)
		end

feature -- Status query

	has_console_manager: BOOLEAN
			--
		do
			Result := has_toolbar and then logging.is_active or log_manager.is_console_manager_active
		end

	has_toolbar: BOOLEAN
			--
		do
			Result := True
		end

feature {NONE} -- Implementation

	extend (v: like item)
			--
		do
			component_box.extend (v)
		end

	extend_unexpanded (v: like item)
			--
		do
			component_box.extend_unexpanded (v)
		end

	blank_space (a_width: INTEGER): EV_FRAME
			--
		do
			create Result
			Result.set_style ({EV_FRAME_CONSTANTS}.Ev_frame_raised)
			Result.set_minimum_width (a_width)
		end

	horizontal_separator (a_height: INTEGER): EV_HORIZONTAL_SEPARATOR
			--
		do
			create Result
			Result.set_minimum_height (a_height)
		end

	vertical_separator (a_width: INTEGER): EV_VERTICAL_SEPARATOR
			--
		do
			create Result
			Result.set_minimum_width (a_width)
		end

	component_box: EL_VERTICAL_BOX

	tool_bar: EL_HORIZONTAL_BOX

feature {NONE} -- Constants

	console_accelerator_keys_enabled: BOOLEAN
			--
		do
			Result := true
		end

	Window_border_cms: REAL
			--
		once
			if not has_wide_theme_border then
				Result := 0.2
			end
		end

	Window_padding_cms: REAL
			--
		once
			Result := 0.1
		end

	Toolbar_border_width: INTEGER
			--
		once
			Result := Screen.horizontal_pixels (0.2)
		end

	Toolbar_padding_width: INTEGER
			--
		once
			Result := Screen.horizontal_pixels (0.2)
		end
end
