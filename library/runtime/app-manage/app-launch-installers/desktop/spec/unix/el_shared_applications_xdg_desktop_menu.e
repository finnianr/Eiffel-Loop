note
	description: "Summary description for {EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

feature -- Access

	Applications_menu: EL_XDG_DESKTOP_MENU
			--
		once
			create Result.make_root ("Applications")
		end

end
