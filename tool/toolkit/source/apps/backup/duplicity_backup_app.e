note
	description: "A command line interface to the class ${REPEATED_DUPLICITY_BACKUP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 15:47:15 GMT (Friday 28th March 2025)"
	revision: "23"

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

	visible_types: TUPLE [
		DUPLICITY_TARGET_INFO_OS_CMD,
		EL_CAPTURED_OS_COMMAND,
		EL_FTP_MIRROR_BACKUP,
		EL_OS_COMMAND,
		EL_FTP_COPY_TREE_COMMAND_IMP,
		EL_RSYNC_COMMAND_IMP
	]
		do
			create Result
		end

end