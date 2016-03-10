note
	description: "Summary description for {EL_GVFS_FILE_EXISTS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GVFS_FILE_EXISTS_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		redefine
			default_create, find_line
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make_with_name ("gvfs-info.type", "[
				gvfs-info -a standard::type "$uri"
			]")
			enable_error_redirection
		end

feature -- Access

	file_exists: BOOLEAN

feature -- Element change

	reset
		do
			file_exists := False
		end

feature {NONE} -- Line states

	find_line (line: ASTRING)
		do
			file_exists := not line.starts_with (Error_message)
			state := agent final
		end

feature {NONE} -- Constants

	Error_message: ASTRING
		once
			Result := "Error getting info"
		end

end
