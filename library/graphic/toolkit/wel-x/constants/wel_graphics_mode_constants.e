note
	description: "Graphicis mode (GM) constants."

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

