note
	description: "Summary description for {EL_GRAPHICS_SYSTEM_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

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
