note
	description: "Xdg constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_XDG_CONSTANTS

inherit
	EL_INSTALLER_DEBUG

feature {NONE} -- Constants

	Applications_desktop_dir: DIR_PATH
			--
		once
			Result := "/usr/share/applications"
			if_installer_debug_enabled (Result)
			-- Workbench debug: "$HOME/.local/share/applications"
		end

	Applications_merged_dir: DIR_PATH
		once
			Result := "/etc/xdg/menus/applications-merged"
			if_installer_debug_enabled (Result)
		end

	Applications_menu: EL_XDG_DESKTOP_MENU
			--
		once
			create Result.make_root (Applications_merged_dir)
		end

	Directories_desktop_dir: DIR_PATH
			--
		once
			Result := "/usr/share/desktop-directories"
			if_installer_debug_enabled (Result)
			-- Workbench debug: $HOME/.local/share/desktop-directories
		end

	Root_item: EL_XDG_DESKTOP_DIRECTORY
		local
			menu_item: EL_DESKTOP_MENU_ITEM
		once
			create menu_item.make_standard ("Applications")
			create Result.make (menu_item, Directories_desktop_dir)
		end

end