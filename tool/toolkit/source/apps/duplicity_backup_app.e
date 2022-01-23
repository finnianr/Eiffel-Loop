note
	description: "A command line interface to the class [$source DUPLICITY_BACKUP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:00:23 GMT (Sunday 23rd January 2022)"
	revision: "13"

class
	DUPLICITY_BACKUP_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [DUPLICITY_BACKUP]
		redefine
			Visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Input file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

	visible_types: TUPLE [EL_OS_COMMAND, EL_CAPTURED_OS_COMMAND, DUPLICITY_TARGET_INFO_OS_CMD]
		do
			create Result
		end

end