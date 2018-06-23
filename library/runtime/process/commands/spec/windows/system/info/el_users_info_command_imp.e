note
	description: "Windows implementation of [$source EL_USERS_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-23 10:07:20 GMT (Saturday 23rd June 2018)"
	revision: "4"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			adjusted_lines
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Implementation

	adjusted_lines (lines: like new_output_lines): EL_ZSTRING_LIST
			-- Remove Public folder name if it exists
		local
			public_path: EL_DIR_PATH
		do
			if attached {STRING_32} Execution_environment.item ("PUBLIC") as public then
				public_path := public
			else
				create public_path
			end
			from lines.start until lines.after loop
				if lines.item ~ public_path.base then
					lines.remove
				else
					lines.forth
				end
			end
			Result := lines
		end

	new_users_dir: EL_DIR_PATH
		do
			Result := Directory.user_profile.parent
		end

feature {NONE} -- Constants

	Template: STRING = "dir /B /AD-S-H $path"
		-- Directories that do not have the hidden or system attribute set

end
