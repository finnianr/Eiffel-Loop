note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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
