note
	description: "Shared applications xdg desktop menu"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

feature -- Access

	Applications_menu: EL_XDG_DESKTOP_MENU
			--
		once
			create Result.make_root ("Applications")
		end

end