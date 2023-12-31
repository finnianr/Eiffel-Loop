note
	description: "[
		Eiffel wrapper for WebKitView object. See: [http://webkitgtk.org/reference/webkitgtk-WebKitWebView.html webkitgtk.org]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 21:45:35 GMT (Thursday 7th July 2016)"
	revision: "1"

class
	EL_WEBKIT_WEB_VIEW

inherit
	EV_WEBKIT_WEB_VIEW
		redefine
			api_loader
		end

	EL_MODULE_OS
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Implementation

	api_loader: DYNAMIC_MODULE
			-- API dynamic loader
		local
			lib_paths: EL_FILE_PATH_LIST
		once
			create lib_paths.make (5)
			across << "/usr/lib", "/usr/lib/x86_64-linux-gnu" >> as dir loop
				-- Mac uses a different extension
				if attached OS.find_files_command (dir.item, "libwebkit*.so") as cmd then
					cmd.set_depth (1 |..| 1)
					cmd.execute
					lib_paths.append (cmd.path_list)
				end
			end
			if lib_paths.count > 0 then
				create Result.make (lib_paths.first_path.without_extension.to_string.to_latin_1)
			else
				Result := Precursor
			end
		end

end

