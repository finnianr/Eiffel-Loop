note
	description: "A command line interface to the class [$source DUPLICITY_BACKUP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-05 16:40:33 GMT (Thursday 5th November 2020)"
	revision: "9"

class
	DUPLICITY_BACKUP_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [DUPLICITY_BACKUP]
		redefine
			Option_name, Visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

	visible_types: TUPLE [EL_CAPTURED_OS_COMMAND, DUPLICITY_TARGET_INFO_OS_CMD]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Create an incremental backup with duplicity command"

	Option_name: STRING = "duplicity"

end