note
	description: "Summary description for {EL_GVFS_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:44:17 GMT (Thursday 24th December 2015)"
	revision: "3"

class
	EL_GVFS_OS_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			find_line as detect_error
		redefine
			detect_error, make_default
		end

create
	make, make_with_name

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			enable_error_redirection
		end

feature -- Status change

	reset
		do
		end

feature {NONE} -- Line states

	detect_error (line: ZSTRING)
		do
			if has_error then
				on_error (colon_value (line))
				state := agent final
			else
				state := agent find_line
				find_line (line)
			end
		end

	find_line (line: ZSTRING)
		do
			state := agent final
		end

feature {NONE} -- Event handling

	on_error (message: ZSTRING)
		local
			exception: DEVELOPER_EXCEPTION
		do
			create exception; exception.set_description (message.to_unicode)
			exception.raise
		end

feature {NONE} -- Implementation

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
