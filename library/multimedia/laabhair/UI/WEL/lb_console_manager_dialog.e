note
	description: "Lb console manager dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

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
