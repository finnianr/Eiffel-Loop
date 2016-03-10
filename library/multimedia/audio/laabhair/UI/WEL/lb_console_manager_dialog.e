note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	LB_CONSOLE_MANAGER_DIALOG

inherit
	EL_CONSOLE_MANAGER_DIALOG
		redefine
			Class_icon
		end
	
	LB_WEL_WINDOW_IDS

create
	make_child

feature {NONE} -- Constants

	Class_icon: WEL_ICON
			-- Window's icon
		once
			create Result.make_by_id (Id_ico_application)
		end

	
end

