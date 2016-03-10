note
	description: "Summary description for {EL_GRAPHICS_SYSTEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-14 18:38:31 GMT (Tuesday 14th May 2013)"
	revision: "2"

class
	EL_SCREEN_PROPERTIES

inherit
	EL_GRAPHICS_SYSTEM_I
		rename
			screen_width as width,
			screen_height as height,
			screen_width_cms as width_cms,
			screen_height_cms as height_cms
		end

	EL_CROSS_PLATFORM_ABS

create
	default_create

feature -- Access

	resolution: STRING
		do
			Result := width.out + "x" + height.out
		end

	horizontal_resolution: REAL
			-- Pixels per centimeter
		do
			Result := Implementation.horizontal_resolution
		end

	vertical_resolution: REAL
			-- Pixels per centimeter
		do
			Result := Implementation.vertical_resolution
		end

	width: INTEGER
			-- screen width in pixels
		do
			Result := Implementation.screen_width
		end

	height: INTEGER
			-- screen height in pixels
		do
			Result := Implementation.screen_height
		end

	width_cms: REAL
			-- screen width in centimeters
		do
			Result := Implementation.screen_width_cms
		end

	height_cms: REAL
			-- screen height in centimeters
		do
			Result := Implementation.screen_height_cms
		end

feature -- Conversion

	horizontal_pixels (cms: REAL): INTEGER
			--
		do
			Result := (horizontal_resolution * cms).rounded
		end

	vertical_pixels (cms: REAL): INTEGER
			--
		do
			Result := (vertical_resolution * cms).rounded
		end

feature -- Status query

	is_windows_aero_theme_active: BOOLEAN
		do
			Result := Implementation.is_windows_aero_theme_active
		end

feature {NONE} -- Implementation

	Implementation: EL_SCREEN_PROPERTIES_IMPL
		once
			create Result.make
		end

end
