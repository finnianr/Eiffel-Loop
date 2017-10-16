note
	description: "Summary description for {EL_FIND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-14 13:44:55 GMT (Tuesday 14th June 2016)"
	revision: "1"

deferred class
	EL_FIND_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL
		redefine
			adjusted, interface
		end

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	 adjusted (lines: EL_LINEAR [ZSTRING]): EL_ZSTRING_LIST
			-- For non-recursive finds prepend path argument to each found path
			-- This is to results of Windows 'dir' command compatible with Unix 'find' command
		local
			file_path: EL_FILE_PATH
		do
			create Result.make (20)

			if interface.is_recursive then
				if not interface.dir_path.is_absolute then
					-- Modify absolute paths to be relative to current working directory
					-- for Linux compatibility
					from lines.start until lines.after loop
						if lines.index = 1 then
							Result.extend (lines.item)
						else
							file_path := lines.item
							Result.extend (file_path.relative_path (Directory.Working))
						end
						lines.forth
					end
				end
			else
				from lines.start until lines.after loop
					if lines.index = 1 then
						Result.extend (lines.item)
					else
						Result.extend (interface.dir_path + lines.item)
					end
					lines.forth
				end
			end
		end

feature {EL_CROSS_PLATFORM} -- Implementation

	interface: EL_FIND_OS_COMMAND [EL_FIND_COMMAND_IMPL, EL_PATH]

end