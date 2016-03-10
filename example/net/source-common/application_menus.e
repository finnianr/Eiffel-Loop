note
	description: "Summary description for {EROS_MULTI_APPLICATION_ROOT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:06 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	APPLICATION_MENUS

inherit
	EL_MODULE_IMAGE_PATH

feature -- Desktop menu entries

	Development_menu: EL_DESKTOP_MENU_ITEM
			-- 'Development' in KDE
			-- 'Programming' in GNOME
		once
			create Result.make_standard ("Development")
		end

	Eiffel_loop_menu: EL_DESKTOP_MENU_ITEM
			--
		once
			create Result.make ("Eiffel Loop", "Eiffel Loop demo applications", Icon_path_eiffel_loop)
		end

	Menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
			--
		once
			Result := <<
				Development_menu, Eiffel_loop_menu,
				create {EL_DESKTOP_MENU_ITEM}.make ("EROS", "Demo applications", Icon_path_EROS)
			>>
		end

feature {NONE} -- Desktop icon paths

	Icon_path_eiffel_loop: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "EL-logo.png" >> )
		end

	Icon_path_EROS: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "eros.png" >> )
		end

	Icon_path_server_menu: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "fourier-server.png" >> )
		end

	Icon_path_server_lite_menu: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "fourier-server-lite.png" >> )
		end

	Icon_path_client_menu: EL_FILE_PATH
			--
		once
			Result := Image_path.desktop_menu_icon (<< "fourier-client.png" >> )
		end

end
