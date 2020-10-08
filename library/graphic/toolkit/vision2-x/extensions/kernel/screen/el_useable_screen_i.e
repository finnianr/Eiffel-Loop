note
	description: "Finds the useable screen area excluding the taskbar etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-08 8:58:10 GMT (Thursday 8th October 2020)"
	revision: "8"

deferred class
	EL_USEABLE_SCREEN_I

inherit
	EL_SOLITARY

feature -- Access

	area: EV_RECTANGLE
			-- useable area not obscured by taskbar

end