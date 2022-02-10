note
	description: "Gvfs os command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 17:34:18 GMT (Thursday 10th February 2022)"
	revision: "11"

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
		local
			f: EL_COLON_FIELD_ROUTINES
		do
			if errors.is_empty then
				Result := "Unknown error"
			else
				Result := f.value (errors.first)
			end
		end

	do_with_lines (a_lines: like new_output_lines)
		do
			parse_lines (initial_state, a_lines)
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
				"File does not exist",							-- Applies to MTP devices (gvfs-rm)
				"File not found", 								-- Applies to MTP devices
				"The specified location is not mounted",	-- Applies to MTP devices
				"No such file or directory"					-- Applies to FUSE file systems
			>>
		end

end