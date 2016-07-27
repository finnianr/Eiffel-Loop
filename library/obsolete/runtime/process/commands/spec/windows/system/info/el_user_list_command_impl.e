note
	description: "Summary description for {EL_USER_LIST_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 11:31:16 GMT (Tuesday 17th May 2016)"
	revision: "4"

class
	EL_USER_LIST_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL
		redefine
			adjusted
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Implementation

	adjusted (lines: EL_ZSTRING_LIST): EL_ZSTRING_LIST
			-- Remove Public folder name if it exists
		local
			public_path: EL_DIR_PATH
		do
			if attached {STRING_32} Execution_environment.item ("PUBLIC") as public then
				public_path := public
				from lines.start until lines.after loop
					if lines.item ~ public_path.base then
						lines.remove
					else
						lines.forth
					end
				end
			end
			Result := lines
		end

feature {NONE} -- Constants

	Template: STRING = "dir /B /AD-S-H $path"
		-- Directories that do not have the hidden or system attribute set
end