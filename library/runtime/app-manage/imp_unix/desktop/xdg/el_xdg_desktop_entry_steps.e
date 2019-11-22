note
	description: "List of items conforming to [$source EL_XDG_DESKTOP_MENU_ITEM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-22 13:25:39 GMT (Friday 22nd November 2019)"
	revision: "2"

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

	make (desktop: EL_MENU_DESKTOP_ENVIRONMENT_I; applications_desktop_dir, directories_desktop_dir: EL_DIR_PATH)
		do
			make_list (desktop.submenu_path.count + 1)
			compare_objects
			across desktop.submenu_path as path loop
				extend (create {EL_XDG_DESKTOP_DIRECTORY}.make (path.item, directories_desktop_dir))
			end
			create launcher.make (desktop, applications_desktop_dir)
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
