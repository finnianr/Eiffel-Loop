note
	description: "Summary description for {EL_GVFS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-04 8:35:14 GMT (Monday 4th July 2016)"
	revision: "1"

class
	EL_GVFS_OS_COMMAND

inherit
	EL_OS_COMMAND
		undefine
			do_command, make_default, new_command_string
		redefine
			on_error
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			template_name, new_temporary_base_name, temporary_error_file_path
		redefine
			make_default, on_error
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		end

	EL_MODULE_EXCEPTION

create
	make, make_with_name

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
			state := agent final
		end

feature {NONE} -- Event handling

	on_error
		do
			Exception.raise_developer (error_message, [])
		end

feature {NONE} -- Line states

	initial_state: like state
		do
			Result := agent find_line
		end

feature {NONE} -- Implementation

	error_message: ZSTRING
		do
			if errors.is_empty then
				Result := "Unknown error"
			else
				Result := colon_value (errors.first)
			end
		end

	do_with_lines (lines: like adjusted_lines)
		do
			parse_lines (initial_state, lines)
		end

	is_file_not_found (message: ZSTRING): BOOLEAN
		do
			Result := across Gvfs_file_not_found_errors as error_ending some message.ends_with (error_ending.item) end
		end

feature {NONE} -- Constants

	Error: ZSTRING
		once
			Result := "Error "
		end

	Gvfs_file_not_found_errors: ARRAY [ZSTRING]
			-- Possible "file not found" errors from gfvs commands
		once
			Result := <<
				"File does not exist", 			-- Applies to MTP devices (gvfs-rm)
				"File not found", 				-- Applies to MTP devices
				"No such file or directory"   -- Applies to FUSE file systems
			>>
		end

end