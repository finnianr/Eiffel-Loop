note
	description: "Windows implementation of [$source EL_FIND_DIRECTORIES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 12:08:21 GMT (Monday 12th July 2021)"
	revision: "7"

class
	EL_FIND_DIRECTORIES_COMMAND_IMP

inherit
	EL_FIND_DIRECTORIES_COMMAND_I
		export
			{NONE} all
		undefine
			adjusted_lines, new_command_parts, get_escaped_path
		end

	EL_FIND_COMMAND_IMP
		rename
			copy_directory_items as copy_sub_directories
		undefine
			make_default, do_command, do_with_lines
		redefine
			new_output_lines
		end

	EL_MODULE_DIRECTORY

create
	make, make_default

feature {NONE} -- Implementation

	new_output_lines (file_path: EL_FILE_PATH): EL_ZSTRING_LIST
		local
			l_path: EL_DIR_PATH
		do
			Result := Precursor (file_path)
			if min_depth = 0 then
				if max_depth > 1 then
					if dir_path.is_absolute then
						l_path := dir_path
					else
						l_path := Directory.current_working.joined_dir_path (dir_path)
					end
				else
					create l_path
				end
				Result.put_front (l_path.to_string)
			end
		end

feature {NONE} -- Constants

	Type: STRING = "D"
end