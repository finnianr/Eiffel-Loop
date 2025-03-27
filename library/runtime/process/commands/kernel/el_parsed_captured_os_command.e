note
	description: "[
		A ${EL_CAPTURED_OS_COMMAND} with arguments parsed and set in the attribute **var** with type
		defined as a class parameter
	]"
	notes: "[
		The names in **VARIABLES** type must occur in the same order as they do in the `default_template'
		or the template passed as an argument to `make_command'.
		
		The initialized variable names can be accessed via the routine `var'.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-26 7:44:31 GMT (Wednesday 26th March 2025)"
	revision: "16"

class
	EL_PARSED_CAPTURED_OS_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_OS_COMMAND [VARIABLES]
		undefine
			do_command, is_captured, make_default, new_command_parts, reset
		end

	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command,
			Var as Standard_var
		export
			{NONE} all
			{ANY} execute, is_valid_platform, has_error, lines, print_error,
					set_working_directory, working_directory
		undefine
			all_variables_set, default_name, execute, make_command
		end

create
	make_command

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