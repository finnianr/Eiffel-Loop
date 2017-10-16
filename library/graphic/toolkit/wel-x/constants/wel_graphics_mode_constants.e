note
	description: "Graphicis mode (GM) constants."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	WEL_GRAPHICS_MODE_CONSTANTS

feature -- Access

	compatible: INTEGER
		external
			"C [macro %"WinGDI.h%"]"
		alias
			"GM_COMPATIBLE"
		end

	advanced: INTEGER
		external
			"C [macro %"WinGDI.h%"]"
		alias
			"GM_ADVANCED"
		end

	last: INTEGER
		external
			"C [macro %"WinGDI.h%"]"
		alias
			"GM_LAST"
		end

feature -- Status report

	valid_modes (c: INTEGER): BOOLEAN
			-- Is `c' a valid map mode constant?
		do
			Result := c = compatible or else
				c = advanced or else
				c = last
		end

end

