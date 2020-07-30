note
	description: "Finds the useable screen area excluding the taskbar etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 11:43:55 GMT (Friday 21st December 2018)"
	revision: "6"

deferred class
	EL_USEABLE_SCREEN_I

feature {NONE} -- Initialization

	make
		deferred
		end

feature -- Access

	area: EV_RECTANGLE
			-- useable area not obscured by taskbar

end
