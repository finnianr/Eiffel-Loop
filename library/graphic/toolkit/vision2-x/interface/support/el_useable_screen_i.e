note
	description: "Finds the useable screen area excluding the taskbar etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 8:49:06 GMT (Monday 12th March 2018)"
	revision: "4"

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
