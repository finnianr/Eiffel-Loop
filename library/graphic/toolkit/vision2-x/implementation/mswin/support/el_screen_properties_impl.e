note
	description: "Summary description for {EL_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-13 11:07:39 GMT (Monday 13th May 2013)"
	revision: "2"

class
	EL_SCREEN_PROPERTIES_IMPL

inherit
	EL_PLATFORM_IMPL

	EV_SCREEN_IMP
		rename
			vertical_resolution as vertical_pixels_per_inch,
			horizontal_resolution as horizontal_pixels_per_inch,
			width as screen_width,
			height as screen_height,
			log as logarithm
		export
			{NONE} all
		end

	EL_GRAPHICS_SYSTEM_I
		undefine
			copy, default_create
		end

	WEL_REGISTRY_ACCESS_MODE
		undefine
			copy, default_create
		end

create
	make

feature -- Access

	horizontal_resolution: REAL
			-- Pixels per centimeter
		do
			Result := screen_width / screen_width_cms
		end

	vertical_resolution: REAL
			-- Pixels per centimeter
		do
			Result := screen_height / screen_height_cms
		end

	screen_width_cms: REAL
			-- screen width in centimeters
		do
			Result := Monitor.width_centimeters
		end

	screen_height_cms: REAL
			-- screen height in centimeters
		do
			Result := Monitor.height_centimeters
		end

	aero_theme: EL_WINDOWS_AERO_THEME
		require
			is_windows_7_or_vista: is_windows_7_or_vista
		once
			create Result.make
		end

feature -- Status query

	is_windows_aero_theme_active: BOOLEAN
			-- True if aero theme active but not Windows Classic theme or derivative
		do
			if is_windows_7_or_vista then
				Result := not aero_theme.is_classic
			end
		end

	is_windows_7_or_vista: BOOLEAN
		local
			registry: WEL_REGISTRY
		once
			create registry
			Result := registry.open_key_with_access (HKCU_desktop_windows_manager, Key_read) /= Default_pointer
		end

feature {NONE} -- Implementation

	Monitor: EL_WEL_DISPLAY_MONITOR_INFO
			--
		once
			create Result
		end

feature {NONE} -- Constants

	HKCU_desktop_windows_manager: STRING = "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM"

end
