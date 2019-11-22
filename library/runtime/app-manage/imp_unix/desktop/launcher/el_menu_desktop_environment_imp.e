note
	description: "[
		Unix implementation of [$source EL_MENU_DESKTOP_ENVIRONMENT_I] interface
		Creates a [https://wiki.archlinux.org/index.php/desktop_entries XDG desktop] menu application launcher
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-22 14:26:31 GMT (Friday 22nd November 2019)"
	revision: "7"

class
	EL_MENU_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_MENU_DESKTOP_ENVIRONMENT_I
		rename
			make as make_desktop
		undefine
			command_path
		end

	EL_DESKTOP_ENVIRONMENT_IMP
		rename
			make as make_desktop
		undefine
			make_desktop
		end

	EL_XDG_CONSTANTS
		rename
			Applications_desktop_dir as Default_applications_desktop_dir,
			Directories_desktop_dir as Default_directories_desktop_dir
		end

	EL_MODULE_LIO

create
	make, make_with_output

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_SUB_APPLICATION)
		do
			make_with_output (installable, Default_applications_desktop_dir, Default_directories_desktop_dir)
		end

	make_with_output (
		installable: EL_INSTALLABLE_SUB_APPLICATION; applications_desktop_dir, directories_desktop_dir: EL_DIR_PATH
	)
		do
			make_desktop (installable)
			create entry_steps.make (Current, applications_desktop_dir, directories_desktop_dir)
		end

feature -- Status query

	launcher_exists: BOOLEAN
			--
		do
			Result := entry_steps.launcher.exists
		end

feature -- Basic operations

	add_menu_entry
			--
		do
			install_entry_steps
			Applications_menu.extend (entry_steps)
			Applications_menu.serialize
		end

	remove_menu_entry
			--
		do
			across entry_steps.non_standard_items as entry loop
				entry.item.uninstall
			end
			Applications_menu.remove
		end

	install_entry_steps
		do
			across entry_steps.non_standard_items as entry loop
				entry.item.install
			end
		end

feature {EL_XDG_CONSTANTS} -- Internal attributes

	entry_steps: EL_XDG_DESKTOP_ENTRY_STEPS

end
