note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 9:42:38 GMT (Thursday 4th August 2016)"
	revision: "2"

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

	new_editor: EIFFEL_LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR
		do
			create Result.make
		end

feature {NONE} -- Constants

	Checksum: ARRAY [NATURAL]
		once
			Result := << 0, 0 >>
		end

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
