note
	description: "[
		Object for locating installed images in Eiffel Loop standard directories
		
		Under Unix these standard directories are (In order searched):
		
			.local/share/<executable name>/icons OR .local/share/<executable name>/images

			/usr/share/<executable name>/icons OR /usr/share/<executable name>/images
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 16:47:55 GMT (Saturday 20th March 2021)"
	revision: "9"

class
	EL_IMAGE_PATH_ROUTINES

inherit
	ANY

	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

feature -- Access

	icon (relative_path_steps: EL_PATH_STEPS): EL_FILE_PATH
		-- application icon
		do
			Result := Icons_path.joined_file_path (relative_path_steps)
		end

	desktop_menu_icon (relative_path_steps: EL_PATH_STEPS): EL_FILE_PATH
		-- Icons for setting up desktop menu launchers
		do
			Result := Desktop_menu_icons_path.joined_file_path (relative_path_steps)
		end

	image (relative_path_steps: EL_PATH_STEPS): EL_FILE_PATH
		-- application image
		do
			Result := Images_path.joined_file_path (relative_path_steps)
		end

feature -- Constants

	Icons_path: EL_DIR_PATH
		once
			Result := Directory.application_installation #+ Step.icons
		end

	Desktop_menu_icons_path: EL_DIR_PATH
		once
			Result := Directory.application_installation #+ Step.desktop_icons
		end

	Images_path: EL_DIR_PATH
		once
			Result := Directory.application_installation #+ Step.images
		end

	User_icons_path: EL_DIR_PATH
		once
			Result := Directory.App_cache #+ Step.icons
		end

	User_desktop_menu_icons_path: EL_DIR_PATH
		once
			Result := Directory.App_cache #+ Step.desktop_icons
		end

	User_images_path: EL_DIR_PATH
		once
			Result := Directory.App_cache #+ Step.images
		end

	Step: TUPLE [icons, desktop_icons, images: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "icons, desktop-icons, images")
		end

end