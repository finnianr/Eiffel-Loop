note
	description: "[
		[https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system] OS command
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:24:45 GMT (Monday 5th December 2022)"
	revision: "16"

class
	EL_GVFS_OS_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		redefine
			make_default, on_error, do_with_lines
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		end

	EL_MODULE_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
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
			if not ignore (message) then
				Exception.raise_developer (message, [])
			end
		end

feature {NONE} -- Line states

	initial_state: like state
		do
			Result := agent find_line
		end

feature {NONE} -- Implementation

	ignore (a_error: ZSTRING): BOOLEAN
		do
		end

	is_file_not_found (message: ZSTRING): BOOLEAN
		do
			Result := across GVFS_file_not_found_errors as error_ending some
							message.ends_with_zstring (error_ending.item)
						end
		end

	do_with_lines (a_lines: like new_output_lines)
		do
			parse_lines (initial_state, a_lines)
		end

feature {NONE} -- Constants

	GVFS_file_not_found_errors: ARRAY [ZSTRING]
		-- Possible "file not found" errors from gfvs commands
		once
			Result := <<
				"File does not exist",							-- Applies to MTP devices (gvfs-rm)
				"File not found", 								-- Applies to MTP devices
				"The specified location is not mounted",	-- Applies to MTP devices
				"No such file or directory"					-- Applies to FUSE file systems
			>>
		end

end