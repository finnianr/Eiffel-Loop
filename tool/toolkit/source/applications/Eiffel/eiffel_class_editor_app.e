note
	description: "Summary description for {EIFFEL_CLASS_EDITOR_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EIFFEL_CLASS_EDITOR_APP

inherit
	EIFFEL_SOURCE_EDIT_SUB_APP
		rename
			file_path as class_file_path
		redefine
			Option_name, Installer
		end

create
	make

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_CLASS_EDITOR
		do
			create Result.make
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 0

	Option_name: STRING = "class_edit"

	Description: STRING = "Auto inserts Access feature attributes with setters"

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Development/Edit class features")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_CLASS_EDITOR_APP}, "*"],
				[{EIFFEL_CLASS_EDITOR}, "*"]
			>>
		end

end
