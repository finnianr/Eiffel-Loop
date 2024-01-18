note
	description: "[
		[https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system] command
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-23 10:24:57 GMT (Tuesday 23rd May 2023)"
	revision: "22"

deferred class
	EL_GVFS_OS_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [VARIABLES]
		redefine
			default_name, execute, make_default, on_error, do_with_lines, reset
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		end

	EL_MODULE_EXCEPTION; EL_MODULE_NAMING; EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

feature -- Basic operations

	execute
		do
			Precursor
			from until not do_retry loop
				Precursor
			end
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
			state := final
		end

feature {NONE} -- Event handling

	on_error (description: EL_ERROR_DESCRIPTION)
		local
			f: EL_COLON_FIELD_ROUTINES; message: ZSTRING
		do
			if description.line_count > 0 then
				message := f.value (description.first_line)
			else
				message := "Unknown error"
			end
			if message.starts_with (Dbus_connection_error) then
				lio.put_new_line
				lio.put_line (message)
				do_retry := User_input.approved_action_y_n ("Retry")
				lio.put_new_line

			elseif not ignore (message) then
				Exception.raise_developer (message, [])
			end
		end

feature {NONE} -- Line states

	initial_state: like state
		do
			Result := agent find_line
		end

feature {NONE} -- Implementation

	default_name (a_template: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := Naming.class_as_snake_lower (Current, 1, 1)
		end

	do_with_lines (a_lines: like new_output_lines)
		do
			parse_lines (initial_state, a_lines)
		end

	ends_with (message, ending: ZSTRING): BOOLEAN
		do
			Result := message.ends_with (ending)
		end

	ignore (a_error: ZSTRING): BOOLEAN
		do
		end

	is_file_not_found (message: ZSTRING): BOOLEAN
		do
			Result := Possible_file_errors.there_exists (agent ends_with (message, ? ))
		end

	reset
		do
			Precursor
			do_retry := False
		end

feature {NONE} -- Internal attributes

	do_retry: BOOLEAN

feature {NONE} -- Constants

	Dbus_connection_error: ZSTRING
		once
			Result := "Error while getting peer-to-peer dbus connection"
		end

	Possible_file_errors: ARRAY [ZSTRING]
		-- Possible "file not found" errors from GFVS commands
		once
			Result := <<
			-- MTP device errors
				"File does not exist", -- (gvfs-rm)
				"File not found",
				"The specified location is not mounted",

			-- FUSE file system errors
				"No such file or directory"
			>>
		end

note
	descendants: "[
			EL_GVFS_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]
				${EL_GVFS_URI_COMMAND}*
					${EL_GVFS_FILE_EXISTS_COMMAND}
					${EL_GVFS_MAKE_DIRECTORY_COMMAND}
					${EL_GVFS_REMOVE_FILE_COMMAND}
					${EL_GVFS_FILE_COUNT_COMMAND}
					${EL_GVFS_FILE_LIST_COMMAND}
					${EL_GVFS_FILE_INFO_COMMAND}
				${EL_GVFS_URI_TRANSFER_COMMAND}*
					${EL_GVFS_COPY_COMMAND}
					${EL_GVFS_MOVE_COMMAND}
				${EL_GVFS_MOUNT_LIST_COMMAND}
	]"
end