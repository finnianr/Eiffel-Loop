note
	description: "Installer debugging aid for EiffelStudio workbench on Linux"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-21 8:17:34 GMT (Tuesday 21st April 2020)"
	revision: "4"

deferred class
	EL_INSTALLER_DEBUG

inherit
	EL_MODULE_DIRECTORY

	EL_MODULE_BUILD_INFO

feature {NONE} -- Implementations

	if_installer_debug_enabled (path: EL_PATH)
		local
			parent: EL_DIR_PATH
		do
			debug ("installer")
				across Parent_dir_map as dir loop
					parent := dir.key
					if parent.is_parent_of (path) then
						path.set_parent_path (dir.item.joined_dir_path (path.parent.relative_path (parent)))
					end
				end
			end
		end

feature {NONE} -- Constants

	Parent_dir_map: EL_HASH_TABLE [EL_DIR_PATH, EL_DIR_PATH]
		once
			create Result.make (<<
				[Directory.new ("/opt"), Directory.Desktop],
				[Directory.new ("/usr"), Directory.Home.joined_dir_path (".local")],
				[Directory.new ("/etc/xdg"),Directory.Home.joined_dir_path (".config")]
			>>)
		end
end
