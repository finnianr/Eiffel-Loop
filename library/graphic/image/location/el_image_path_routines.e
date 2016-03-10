note
	description: "[
		Object for locating installed images in Eiffel Loop standard directories
		
		Under Unix these standard directories are (In order searched):
		
			.local/share/<executable name>/icons OR .local/share/<executable name>/images

			/usr/share/<executable name>/icons OR /usr/share/<executable name>/images
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:07:58 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_IMAGE_PATH_ROUTINES

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

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
			--
		once
			Result := Execution_environment.Application_installation_dir.joined_dir_path (Step_icons)
		end

	Desktop_menu_icons_path: EL_DIR_PATH
			--
		once
			Result := Execution_environment.Application_installation_dir.joined_dir_path (Step_desktop_icons)
		end

	Images_path: EL_DIR_PATH
			--
		once
			Result := Execution_environment.Application_installation_dir.joined_dir_path (Step_images)
		end

	User_icons_path: EL_DIR_PATH
			--
		once
			Result := Execution_environment.User_configuration_dir.joined_dir_path (Step_icons)
		end

	User_desktop_menu_icons_path: EL_DIR_PATH
			--
		once
			Result := Execution_environment.User_configuration_dir.joined_dir_path (Step_desktop_icons)
		end

	User_images_path: EL_DIR_PATH
			--
		once
			Result := Execution_environment.User_configuration_dir.joined_dir_path (Step_images)
		end

	Step_icons: EL_ASTRING
		once
			Result := "icons"
		end

	Step_desktop_icons: EL_ASTRING
		once
			Result := "desktop-icons"
		end

	Step_images: EL_ASTRING
		once
			Result := "images"
		end

end