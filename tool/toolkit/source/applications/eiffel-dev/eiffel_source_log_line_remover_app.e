note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:14:32 GMT (Friday 8th July 2016)"
	revision: "4"

class
	EIFFEL_SOURCE_LOG_LINE_REMOVER_APP

inherit
	EIFFEL_SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, Installer
		end

create
	make

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR
		do
			create Result.make
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 0

	Option_name: STRING = "elog_remover"

	Description: STRING = "Comment out logging lines from Eiffel source code tree"

	Installer: EL_APPLICATION_INSTALLER_I
		once
			Result := new_context_menu_installer ("Eiffel Loop/Development/Comment out logging lines")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_SOURCE_LOG_LINE_REMOVER_APP}, All_routines]
			>>
		end

end