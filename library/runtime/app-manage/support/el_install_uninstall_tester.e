note
	description: "Installer testing aid for EiffelStudio workbench on Linux"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 15:20:25 GMT (Wednesday 25th September 2024)"
	revision: "12"

frozen class
	EL_INSTALL_UNINSTALL_TESTER

inherit
	ANY

	EL_MODULE_BUILD_INFO; EL_MODULE_DIRECTORY

	EL_SHARED_APPLICATION_OPTION

feature -- Status query

	testing: BOOLEAN
		do
			Result := App_option.test
		end

feature -- Access

	absolute_path (a_dir_path: DIR_PATH; file_path: FILE_PATH): FILE_PATH
		local
			dir_path: DIR_PATH
		do
			dir_path := a_dir_path
			if testing then
				if a_dir_path = Directory.applications then
					dir_path := Directory.desktop
				end
			end
			Result := dir_path.plus_file (file_path)
		end

feature -- Basic operations

	adjust_parent (path: EL_PATH)
		local
			parent: DIR_PATH
		do
			if testing then
				across Parent_dir_map as dir loop
					parent := dir.key
					if parent.is_parent_of (path) then
						path.set_parent (dir.item.plus_dir (path.parent.relative_path (parent)))
					end
				end
			else
				do_nothing
			end
		end

feature {NONE} -- Implementation

	new_parent_dir_map: EL_HASH_TABLE [DIR_PATH, STRING]
		do
			Result := <<
				["/opt",		 Directory.Desktop],
				["/usr",		 Directory.Home #+ ".local"],
				["/etc/xdg", Directory.Home #+ ".config"]
			>>
		end

feature {NONE} -- Constants

	Parent_dir_map: EL_HASH_TABLE [DIR_PATH, DIR_PATH]
		once
			if attached new_parent_dir_map as dir_map then
				create Result.make_equal (dir_map.count)
				across dir_map as table loop
					Result.put (table.item, table.key)
				end
			end
		end
end