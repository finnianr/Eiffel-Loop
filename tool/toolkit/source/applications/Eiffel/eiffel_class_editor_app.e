note
	description: "Summary description for {EIFFEL_CLASS_EDITOR_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

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
