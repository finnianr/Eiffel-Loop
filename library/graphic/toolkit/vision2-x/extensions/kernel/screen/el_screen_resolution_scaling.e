note
	description: "Screen resolution scaling"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 11:37:17 GMT (Friday 21st December 2018)"
	revision: "5"

class
	EL_SCREEN_RESOLUTION_SCALING

feature -- Status query

	is_base_resolution: BOOLEAN
			-- Does the resolution of this machine match the base
		do
			Result := Screen.height = base_height
		end

feature -- Measurement

	Base_height: INTEGER  = 600
			--

	scaled (pixels: INTEGER): INTEGER
			--  pixels scaled to current screen resolution
		do
			Result := ((pixels * screen.height) / Base_height).rounded
		end

feature {NONE} -- Implementation

	Screen: EV_SCREEN
			--
		once
			create Result
		end

end