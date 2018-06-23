note
	description: "Shared instance of [$source EL_XDG_DESKTOP_MENU]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-09 8:31:08 GMT (Saturday 9th June 2018)"
	revision: "5"

class
	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

feature -- Access

	Applications_menu: EL_XDG_DESKTOP_MENU
			--
		once
			create Result.make_root
		end

end
