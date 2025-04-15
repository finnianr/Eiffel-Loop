note
	description: "Class renaming app for set of classes defined by source manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 9:30:41 GMT (Tuesday 15th April 2025)"
	revision: "32"

class
	CLASS_RENAMING_APP

inherit
	SOURCE_MANIFEST_APPLICATION [CLASS_RENAMING_COMMAND_SHELL]
		redefine
			Option_name
		end

	EL_INSTALLABLE_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Rename a class")
		end

	Option_name: STRING = "class_rename"

end