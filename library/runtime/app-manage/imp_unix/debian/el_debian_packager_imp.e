note
	description: "Unix implementation of [$source EL_DEBIAN_PACKAGER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:02:06 GMT (Thursday 13th January 2022)"
	revision: "3"

class
	EL_DEBIAN_PACKAGER_IMP

inherit
	EL_DEBIAN_PACKAGER_I
		redefine
			description
		end

	EL_XDG_CONSTANTS
		rename
			Applications_menu as Default_applications_menu
		end

create
	make

feature -- Constants

	Description: STRING = "Create a Debian package in output directory for this application"

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
			configuration_file_list.extend (Applications_merged_dir + applications_menu.output_path.base)
		end

end