note
	description: "Shared instance of [$source EL_XDG_DESKTOP_MENU]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:28 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

inherit
	EL_ANY_SHARED

feature -- Access

	Applications_menu: EL_XDG_DESKTOP_MENU
			--
		once
			create Result.make_root
		end

end
