note
	description: "Access to shared instance of [$source EL_GTK_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-29 10:17:14 GMT (Wednesday 29th July 2020)"
	revision: "1"

deferred class
	EL_MODULE_GTK

inherit
	EL_MODULE

feature {NONE} -- Constants

	GTK: EL_GTK_ROUTINES
		once
			create Result
		end

end
