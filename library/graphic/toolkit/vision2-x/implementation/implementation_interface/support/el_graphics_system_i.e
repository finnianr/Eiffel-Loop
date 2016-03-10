note
	description: "Summary description for {EL_GRAPHICS_SYSTEM_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-12 10:01:11 GMT (Sunday 12th May 2013)"
	revision: "2"

deferred class
	EL_GRAPHICS_SYSTEM_I

feature -- Access

	horizontal_resolution: REAL
			-- Pixels per centimeter
		deferred
		end

	vertical_resolution: REAL
			-- Pixels per centimeter
		deferred
		end

	screen_width: INTEGER
			-- screen width in pixels
		deferred
		end

	screen_height: INTEGER
			-- screen height in pixels
		deferred
		end

	screen_width_cms: REAL
			-- screen width in centimeters
		deferred
		end

	screen_height_cms: REAL
			-- screen height in centimeters
		deferred
		end

end
