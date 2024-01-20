note
	description: "A command line interface to the class ${DUPLICITY_RESTORE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "22"

class
	DUPLICITY_RESTORE_APP

inherit
	EL_COMMAND_LINE_APPLICATION [DUPLICITY_RESTORE]
		redefine
			Option_name, visible_types
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

	visible_types: TUPLE [
		DUPLICITY_COLLECTION_STATUS_OS_CMD,
		DUPLICITY_LISTING_OS_CMD,
		DUPLICITY_RESTORE_ALL_OS_CMD,
		DUPLICITY_RESTORE_FILE_OS_CMD
	]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "duplicity_restore"

end