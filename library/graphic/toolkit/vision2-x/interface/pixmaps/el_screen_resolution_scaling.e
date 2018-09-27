note
	description: "Screen resolution scaling"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

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