note
	description: "[
		Common class to make the following example projects installable:
		
		* [./example/net/EROS/signal-math/signal-math.project.html example/net/EROS/signal-math/signal-math.ecf]
		* [./example/net/EROS/server/signal-math-server.project.html example/net/EROS/server/signal-math-server.ecf]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	INSTALLABLE_EROS_SUB_APPLICATION

inherit
	EL_INSTALLABLE_APPLICATION

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