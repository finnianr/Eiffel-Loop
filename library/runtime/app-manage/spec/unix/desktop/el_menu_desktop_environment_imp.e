note
	description: "[
		Unix implementation of [$source EL_MENU_DESKTOP_ENVIRONMENT_I] interface
		Creates a [https://wiki.archlinux.org/index.php/desktop_entries XDG desktop] menu application launcher
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-20 10:46:31 GMT (Wednesday 20th June 2018)"
	revision: "6"

class
	EL_MENU_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_MENU_DESKTOP_ENVIRONMENT_I
		undefine
			command_path
		redefine
			make
		end

	EL_DESKTOP_ENVIRONMENT_IMP
		undefine
			make
		end

	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_SUB_APPLICATION)
		do
			Precursor {EL_MENU_DESKTOP_ENVIRONMENT_I} (installable)
			create entry_steps.make (Current)
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
			entry_steps.non_standard_items.do_all (agent {EL_XDG_DESKTOP_MENU_ITEM}.install)
			Applications_menu.extend (entry_steps)
			Applications_menu.serialize
		end

	remove_menu_entry
			--
		do
			entry_steps.non_standard_items.do_all (agent {EL_XDG_DESKTOP_MENU_ITEM}.uninstall)
			Applications_menu.remove
		end

feature {NONE} -- Internal attributes

	entry_steps: EL_XDG_DESKTOP_ENTRY_STEPS

end
