note
	description: "Installer debugging aid for EiffelStudio workbench on Linux"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:20:27 GMT (Monday 14th February 2022)"
	revision: "6"

deferred class
	EL_INSTALLER_DEBUG

inherit
	EL_MODULE_DIRECTORY

	EL_MODULE_BUILD_INFO

feature {NONE} -- Implementations

	if_installer_debug_enabled (path: EL_PATH)
		local
			parent: DIR_PATH
		do
			debug ("installer")
				across Parent_dir_map as dir loop
					parent := dir.key
					if parent.is_parent_of (path) then
						path.set_parent_path (dir.item #+ path.parent.relative_path (parent))
					end
				end
			end
		end

feature {NONE} -- Constants

	Parent_dir_map: EL_HASH_TABLE [DIR_PATH, DIR_PATH]
		once
			create Result.make (<<
				[Directory.new ("/opt"), Directory.Desktop],
				[Directory.new ("/usr"), Directory.Home #+ ".local"],
				[Directory.new ("/etc/xdg"),Directory.Home #+ ".config"]
			>>)
		end
end