note
	description: "Summary description for {SHARED_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_CONSTANTS

feature -- Access

	Screen: EV_SCREEN
		once
			create Result
		end

	Half_screen_width: INTEGER
		once
			Result := Screen.width // 2
		end

	Page_width: INTEGER
		once
			Result := (Half_screen_width * 0.9).rounded
		end

	Colors: EV_STOCK_COLORS
		once
			create Result
		end

end
