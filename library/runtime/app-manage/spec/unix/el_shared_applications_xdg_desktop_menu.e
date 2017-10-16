note
	description: "Summary description for {EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

feature -- Access

	Applications_menu: EL_XDG_DESKTOP_MENU
			--
		once
			create Result.make_root ("Applications")
		end

end