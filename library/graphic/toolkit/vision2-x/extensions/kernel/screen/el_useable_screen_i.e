note
	description: "Finds the useable screen area excluding the taskbar etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:43:13 GMT (Sunday 5th November 2023)"
	revision: "10"

deferred class
	EL_USEABLE_SCREEN_I

inherit
	ANY
	
	EL_SOLITARY

feature -- Access

	area: EV_RECTANGLE
			-- useable area not obscured by taskbar

end