note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:22:47 GMT (Thursday 29th June 2017)"
	revision: "3"

class
	SOURCE_LOG_LINE_REMOVER_APP

inherit
	SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, Installer
		end

create
	make

feature {NONE} -- Implementation

	new_editor: LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{SOURCE_LOG_LINE_REMOVER_APP}, All_routines]
			>>
		end

end