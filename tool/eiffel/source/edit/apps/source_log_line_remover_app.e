note
	description: "Source log line remover app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:38:33 GMT (Friday 6th November 2020)"
	revision: "12"

class
	SOURCE_LOG_LINE_REMOVER_APP

inherit
	SOURCE_TREE_EDITING_SUB_APPLICATION
		rename
			extra_log_filter_list as empty_log_filter_list
		redefine
			Option_name
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

create
	make

feature {NONE} -- Implementation

	new_editor (file_path_list: LIST [EL_FILE_PATH]): LOG_LINE_COMMENTING_OUT_SOURCE_EDITOR
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

	desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Comment out logging lines")
		end

end