note
	description: "[
		Remove duplicate lines and short commands from bash history file.
		Short means <= 4 characters in length.
	]"
	notes: "[
		**Usage:**
		
			el_toolkit -trim_bash_history
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-23 8:38:24 GMT (Wednesday 23rd October 2024)"
	revision: "2"

class
	TRIM_BASH_HISTORY_APP

inherit
	EL_APPLICATION

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	initialize
		do
			history_path := Directory.home + ".bash_history"
			clean_history_path := history_path.twin
			clean_history_path.add_extension ("trim")
			create line_set.make (1000)
		end

feature -- Basic operations

	run
		do
			if attached open (clean_history_path, Write) as file_out then
				across File.plain_text_lines (history_path) as line loop
					if attached line.item as ln then
						if ln.count > 4 and then not line_set.has (ln) then
							line_set.put (ln)
							if line_set.count > 1 then
								file_out.put_new_line
							end
							file_out.put_encoded_string_8 (ln)
						end
					end
				end
				file_out.close
			end
			File_system.remove_file (history_path)
			File_system.rename_file (clean_history_path, history_path)
			execution.system ("history -r")
		end

feature {NONE} -- Internal attributes

	history_path: FILE_PATH

	clean_history_path: FILE_PATH

	line_set: EL_HASH_SET [STRING]

feature {NONE} -- Constants

	Description: STRING = "Remove duplicate lines and short commands from bash history"
end