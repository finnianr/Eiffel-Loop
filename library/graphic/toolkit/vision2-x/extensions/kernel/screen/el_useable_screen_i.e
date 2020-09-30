note
	description: "Finds the useable screen area excluding the taskbar etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-23 16:02:28 GMT (Wednesday 23rd September 2020)"
	revision: "7"

deferred class
	EL_USEABLE_SCREEN_I

inherit
	EL_SHARED_SINGLETONS

feature {NONE} -- Initialization

	make
		do
			put_singleton (Current)
		end

feature -- Access

	area: EV_RECTANGLE
			-- useable area not obscured by taskbar

end