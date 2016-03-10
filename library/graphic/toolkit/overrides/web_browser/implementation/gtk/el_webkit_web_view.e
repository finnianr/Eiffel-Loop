note
	description: "[
					Eiffel wrapper for WebKitView object
					see: http://webkitgtk.org/reference/webkitgtk-WebKitWebView.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-05 12:17:48 GMT (Friday 5th September 2014)"
	revision: "4"

class
	EL_WEBKIT_WEB_VIEW

inherit
	EV_WEBKIT_WEB_VIEW
		redefine
			api_loader
		end

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Implementation

	api_loader: DYNAMIC_MODULE
			-- API dynamic loader
		local
			find_files_command: EL_FIND_FILES_COMMAND
			lib_paths: ARRAYED_LIST [EL_FILE_PATH]
		once
			create lib_paths.make (5)
			across << "/usr/lib", "/usr/lib/x86_64-linux-gnu" >> as dir loop
				create find_files_command.make (dir.item, "libwebkit*.so") -- Mac uses a different extension
				find_files_command.disable_recursion
				find_files_command.set_follow_symbolic_links (True)
				find_files_command.execute
				lib_paths.append (Find_files_command.path_list)
			end

			if not lib_paths.is_empty then
				create Result.make (lib_paths.first.without_extension.to_string.to_latin1)
			end
		end

end

