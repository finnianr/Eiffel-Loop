note
	description: "List of items conforming to ${EL_XDG_DESKTOP_MENU_ITEM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

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

	make (desktop: EL_MENU_DESKTOP_ENVIRONMENT_I; applications_desktop_dir, directories_desktop_dir: DIR_PATH)
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

	non_standard_items: LIST [EL_XDG_DESKTOP_MENU_ITEM]
			--
		do
			Result := inverse_query_if (agent {EL_XDG_DESKTOP_MENU_ITEM}.is_standard)
		end

end