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
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "11"

class
	EL_IMAGE_PATH_ROUTINES

inherit
	ANY

	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
		do
			installation_dir := Directory.Application_installation
		end

feature -- Access

	desktop_menu_icon (relative_path_steps: EL_PATH_STEPS): FILE_PATH
		-- Icons for setting up desktop menu launchers
		do
			Result := Desktop_menu_icons_path.joined_file_path (relative_path_steps)
		end

	icon (relative_path_steps: EL_PATH_STEPS): FILE_PATH
		-- application icon
		do
			Result := Icons_path.joined_file_path (relative_path_steps)
		end

	image (relative_path_steps: EL_PATH_STEPS): FILE_PATH
		-- application image
		do
			Result := Images_path.joined_file_path (relative_path_steps)
		end

feature -- Element change

	set_installation_dir (a_installation_dir: DIR_PATH)
		-- used for installers when images are taken from unzipped package
		do
			installation_dir := a_installation_dir
		end

feature -- Constants

	Desktop_menu_icons_path: DIR_PATH
		once
			Result := installation_dir #+ Step.desktop_icons
		end

	Icons_path: DIR_PATH
		once
			Result := installation_dir #+ Step.icons
		end

	Images_path: DIR_PATH
		once
			Result := installation_dir #+ Step.images
		end

	Step: TUPLE [icons, desktop_icons, images: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "icons, desktop-icons, images")
		end

	User_desktop_menu_icons_path: DIR_PATH
		once
			Result := Directory.App_cache #+ Step.desktop_icons
		end

	User_icons_path: DIR_PATH
		once
			Result := Directory.App_cache #+ Step.icons
		end

	User_images_path: DIR_PATH
		once
			Result := Directory.App_cache #+ Step.images
		end

feature {NONE} -- Internal attributes

	installation_dir: DIR_PATH

end
