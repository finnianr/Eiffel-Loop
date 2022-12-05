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
	date: "2022-12-05 9:26:11 GMT (Monday 5th December 2022)"
	revision: "15"

class
	EL_IMAGE_PATH_LOCATIONS

inherit
	ANY

	EL_MODULE_DIRECTORY

	EL_MODULE_TUPLE

create
	make, make_default

feature {NONE} -- Initialization

	make (installation_dir: DIR_PATH)
		do
			desktop_icons_dir := installation_dir #+ Step.desktop_icons
			icons_dir := installation_dir #+ Step.icons
			images_dir := installation_dir #+ Step.images
		end

	make_default
		do
			create desktop_icons_dir
			create icons_dir
			create images_dir
		end

feature -- Access

	desktop_menu_icon (relative_path: FILE_PATH): FILE_PATH
		-- Icons for setting up desktop menu launchers
		do
			Result := desktop_icons_dir + relative_path
		end

	icon (relative_path: FILE_PATH): FILE_PATH
		-- application icon
		do
			Result := icons_dir + relative_path
		end

	image (relative_path: FILE_PATH): FILE_PATH
		-- application image
		do
			Result := images_dir + relative_path
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