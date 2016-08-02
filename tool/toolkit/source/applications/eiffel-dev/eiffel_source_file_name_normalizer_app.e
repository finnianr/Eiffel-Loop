note
	description: "Summary description for {EIFFEL_SOURCE_FILENAME_NORMALIZER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:15:13 GMT (Friday 8th July 2016)"
	revision: "1"

class
	EIFFEL_SOURCE_FILE_NAME_NORMALIZER_APP

inherit
	EIFFEL_SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, Installer
		end

create
	make

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_CLASS_FILE_NAME_NORMALIZER
		do
			create Result.make
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 0

	Option_name: STRING = "normalize_class_file_name"

	Description: STRING = "Normalize class filenames as lowercase classnames within a source directory"

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/Development/Normalize class filenames")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_SOURCE_FILE_NAME_NORMALIZER_APP}, All_routines],
				[{EIFFEL_CLASS_FILE_NAME_NORMALIZER}, All_routines]
			>>
		end

end