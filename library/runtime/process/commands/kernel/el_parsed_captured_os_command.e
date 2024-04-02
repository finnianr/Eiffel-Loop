note
	description: "[
		A ${EL_CAPTURED_OS_COMMAND} with arguments parsed and set in the attribute **var** with type
		defined as a class parameter
	]"
	notes: "[
		The names in **VARIABLES** type must occur in the same order as they do in the **template**
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 10:24:49 GMT (Tuesday 2nd April 2024)"
	revision: "12"

deferred class
	EL_PARSED_CAPTURED_OS_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_OS_COMMAND [VARIABLES]
		undefine
			do_command, is_captured, make_default, new_command_parts, reset
		end

	EL_CAPTURED_OS_COMMAND
		rename
			template as command_template,
			make as make_command,
			Var as Standard_var
		export
			{NONE} all
			{ANY} set_working_directory, execute, is_valid_platform, has_error, lines, print_error,
				working_directory
		undefine
			default_name, execute, make_command
		end
note
	descendants: "[
			EL_PARSED_CAPTURED_OS_COMMAND* [VARIABLES -> ${TUPLE} create default_create end]
				${EL_GVFS_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]}
					${EL_GVFS_MOUNT_LIST_COMMAND}
					${EL_GVFS_URI_COMMAND*}
						${EL_GVFS_FILE_LIST_COMMAND}
						${EL_GVFS_FILE_INFO_COMMAND}
						${EL_GVFS_FILE_EXISTS_COMMAND}
						${EL_GVFS_FILE_COUNT_COMMAND}
						${EL_GVFS_MAKE_DIRECTORY_COMMAND}
						${EL_GVFS_REMOVE_FILE_COMMAND}
					${EL_GVFS_URI_TRANSFER_COMMAND*}
						${EL_GVFS_MOVE_COMMAND}
						${EL_GVFS_COPY_COMMAND}
				${EL_GET_GNOME_SETTING_COMMAND}
	]"
end