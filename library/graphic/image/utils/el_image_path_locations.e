note
	description: "[
		Object for locating installed images in Eiffel Loop standard directories
		
		Under Unix these standard directories are (In order searched):
		
			.local/share/<executable name>/icons OR .local/share/<executable name>/images

			/usr/share/<executable name>/icons OR /usr/share/<executable name>/images
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-12-10 11:30:51 GMT (Tuesday 10th December 2024)"
	revision: "17"

class
	EL_IMAGE_PATH_LOCATIONS

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

create
	default_create, make

feature {NONE} -- Initialization

	default_create
		do
			create desktop_icons_dir
			create icons_dir
			create images_dir
		end

	make (installation_dir: DIR_PATH)
		do
			desktop_icons_dir := installation_dir #+ Step.desktop_icons
			icons_dir := installation_dir #+ Step.icons
			images_dir := installation_dir #+ Step.images
		end

feature -- Access

	desktop_menu_icon (relative_path: FILE_PATH): FILE_PATH
		-- Icons for setting up desktop menu launchers
		do
			Result := desktop_icons_dir.plus_file (relative_path)
		end

	icon (relative_path: FILE_PATH): FILE_PATH
		-- application icon
		do
			Result := icons_dir.plus_file (relative_path)
		end

	image (relative_path: FILE_PATH): FILE_PATH
		-- application image
		do
			Result := images_dir.plus_file (relative_path)
		end

feature -- Base directories

	desktop_icons_dir: DIR_PATH

	icons_dir: DIR_PATH

	images_dir: DIR_PATH

feature -- Constants

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

end