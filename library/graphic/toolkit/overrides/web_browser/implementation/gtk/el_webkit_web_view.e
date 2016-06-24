note
	description: "[
		Eiffel wrapper for WebKitView object
		see: http://webkitgtk.org/reference/webkitgtk-WebKitWebView.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 18:16:42 GMT (Monday 20th June 2016)"
	revision: "6"

class
	EL_WEBKIT_WEB_VIEW

inherit
	EV_WEBKIT_WEB_VIEW
		redefine
			api_loader
		end

	EL_MODULE_COMMAND
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Implementation

	api_loader: DYNAMIC_MODULE
			-- API dynamic loader
		local
			find_files_cmd: like Command.new_find_files
			lib_paths: ARRAYED_LIST [EL_FILE_PATH]
		once
			create lib_paths.make (5)
			across << "/usr/lib", "/usr/lib/x86_64-linux-gnu" >> as dir loop
				find_files_cmd := Command.new_find_files (dir.item, "libwebkit*.so") -- Mac uses a different extension
				find_files_cmd.set_depth (1 |..| 1)
				find_files_cmd.set_follow_symbolic_links (True)
				find_files_cmd.execute
				lib_paths.append (find_files_cmd.path_list)
			end

			if not lib_paths.is_empty then
				create Result.make (lib_paths.first.without_extension.to_string.to_latin_1)
			end
		end

end

