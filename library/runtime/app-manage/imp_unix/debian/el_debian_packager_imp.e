note
	description: "Unix implementation of [$source EL_DEBIAN_PACKAGER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 18:28:51 GMT (Sunday 24th November 2019)"
	revision: "1"

class
	EL_DEBIAN_PACKAGER_IMP

inherit
	EL_DEBIAN_PACKAGER_I

	EL_XDG_CONSTANTS
		rename
			Applications_menu as Default_applications_menu
		end

create
	make

feature {NONE} -- Implementation

	put_xdg_entries
		local
			menu_desktop: EL_MENU_DESKTOP_ENVIRONMENT_IMP
			applications_menu: EL_XDG_DESKTOP_MENU
		do
			create applications_menu.make_root (package_sub_dir (Applications_merged_dir))
			across Application_list.installable_list as installable loop
				create menu_desktop.make_relocated (installable.item, agent package_sub_dir)
				menu_desktop.install_entry_steps
				applications_menu.extend (menu_desktop.entry_steps)
			end
			applications_menu.serialize
		end

end
