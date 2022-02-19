note
	description: "A command line interface to the class [$source REPEATED_DUPLICITY_BACKUP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 15:09:17 GMT (Saturday 19th February 2022)"
	revision: "16"

class
	DUPLICITY_BACKUP_APP

inherit
	EL_COMMAND_LINE_APPLICATION [REPEATED_DUPLICITY_BACKUP]
		redefine
			Visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Input file path or wildcard `<dir-name>/*.pyx'", << at_least_one_file_must_exist >>)
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