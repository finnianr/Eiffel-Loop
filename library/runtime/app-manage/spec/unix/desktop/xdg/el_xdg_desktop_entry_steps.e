note
	description: "List of items conforming to [$source EL_XDG_DESKTOP_MENU_ITEM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-10 11:03:07 GMT (Sunday 10th June 2018)"
	revision: "1"

class
	EL_XDG_DESKTOP_ENTRY_STEPS

inherit
	EL_ARRAYED_LIST [EL_XDG_DESKTOP_MENU_ITEM]
		rename
			make as make_list
		end

create
	make

feature {NONE} -- Initialization

	make (desktop: EL_MENU_DESKTOP_ENVIRONMENT_I)
		do
			make_list (desktop.submenu_path.count + 1)
			compare_objects
			across desktop.submenu_path as path loop
				extend (create {EL_XDG_DESKTOP_DIRECTORY}.make (path.item))
			end
			create launcher.make (desktop)
			extend (launcher)
		end

feature -- Access

	launcher: EL_XDG_DESKTOP_LAUNCHER

	non_standard_items: ARRAYED_LIST [EL_XDG_DESKTOP_MENU_ITEM]
			--
		do
			create Result.make (count)
			across Current as menu loop
				if not menu.item.is_standard then
					Result.extend (menu.item)
				end
			end
		end

end
