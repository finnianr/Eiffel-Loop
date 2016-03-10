note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

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

	Installer: EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER
		once
			create Result.make ("Eiffel Loop/Development/Comment out logging lines")
		end
		
	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_SOURCE_LOG_LINE_REMOVER_APP}, "*"],
				[{EIFFEL_SOURCE_TREE_PROCESSOR}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
