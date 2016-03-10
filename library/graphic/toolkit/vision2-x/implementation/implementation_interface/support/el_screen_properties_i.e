note
	description: "Summary description for {EL_GRAPHICS_SYSTEM_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 12:23:23 GMT (Wednesday 24th June 2015)"
	revision: "4"

deferred class
	EL_SCREEN_PROPERTIES_I

feature -- Access

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
