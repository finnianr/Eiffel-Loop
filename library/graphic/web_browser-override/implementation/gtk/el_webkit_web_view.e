note
	description: "[
					Eiffel wrapper for WebKitView object
					see: http://webkitgtk.org/reference/webkitgtk-WebKitWebView.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 13:08:08 GMT (Monday 24th June 2013)"
	revision: "2"

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
			lib_path: EL_FILE_PATH
		once
			create find_files_command.make ("/usr/lib", "libwebkit*.so") -- Mac uses a different extension
			find_files_command.disable_recursion
			find_files_command.set_follow_symbolic_links (True)
			find_files_command.execute

			if not find_files_command.path_list.is_empty then
				lib_path := Find_files_command.path_list.first
				create Result.make (lib_path.without_extension.to_string.to_latin1)
			end
		end

end

