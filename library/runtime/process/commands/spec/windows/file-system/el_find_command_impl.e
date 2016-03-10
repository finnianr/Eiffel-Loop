note
	description: "Summary description for {EL_FIND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 11:30:55 GMT (Friday 24th January 2014)"
	revision: "3"

deferred class
	EL_FIND_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL
		redefine
			adjust
		end

	EL_MODULE_DIRECTORY

feature -- Basic operations

	adjust (find_command: EL_FIND_OS_COMMAND [EL_FIND_COMMAND_IMPL, EL_PATH]; output_file_path: EL_FILE_PATH)
			-- For non-recursive finds prepend path argument to each found path
			-- This is to results of Windows 'dir' command compatible with Unix 'find' command
		local
			lines: EL_FILE_LINE_SOURCE
			modified_paths: LINKED_LIST [EL_FILE_PATH]
			lines_modified: BOOLEAN
			file: PLAIN_TEXT_FILE
			file_path: EL_FILE_PATH
		do
			create lines.make (output_file_path)

			lines.set_encoding ("UTF", 8)
				-- This assumes that the UTF-8 code page console output has been set
				-- See class EL_EXECUTION_ENVIRONMENT

			create modified_paths.make
			if find_command.is_recursive then
				if not find_command.dir_path.is_absolute then
					-- Modify absolute paths to be relative to current working directory
					-- for Linux compatibility
					across lines as line loop
						if line.cursor_index = 1 then
							modified_paths.extend (line.item)
						else
							file_path := line.item
							modified_paths.extend (file_path.relative_path (Directory.Working))
						end
					end
					lines_modified := True
				end
			else
				across lines as line loop
					if line.cursor_index = 1 then
						modified_paths.extend (line.item)
					else
						modified_paths.extend (find_command.dir_path + line.item)
					end
				end
				lines_modified := True
			end
			if lines_modified then
				create file.make_open_write (output_file_path.unicode)
				across modified_paths as path loop
					file.put_string (path.item.unicode)
					file.put_new_line
				end
				file.close
			end
		end

end
