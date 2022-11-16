note
	description: "Lb console manager dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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