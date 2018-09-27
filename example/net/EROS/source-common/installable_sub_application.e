note
	description: "Application menus"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	INSTALLABLE_SUB_APPLICATION

inherit
	EL_INSTALLABLE_SUB_APPLICATION

feature -- Desktop menu entries

	Desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
			--
		once
			Result := <<
				new_category ("Development"), -- 'Development' in KDE, 'Programming' in GNOME
				new_custom_category ("Eiffel Loop", "Eiffel Loop demo applications", "EL-logo.png"),
				new_custom_category ("EROS", "Demo applications", "eros.png")
			>>
		end

end
