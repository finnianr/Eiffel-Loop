note
	description: "Finds the useable screen area excluding the taskbar etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_USEABLE_SCREEN_I

inherit
	EL_SOLITARY

feature -- Access

	area: EV_RECTANGLE
			-- useable area not obscured by taskbar

end