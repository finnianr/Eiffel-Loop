note
	description: "Windows implementation of `EL_FIND_DIRECTORIES_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 17:51:34 GMT (Monday 20th June 2016)"
	revision: "4"

class
	EL_FIND_DIRECTORIES_COMMAND_IMP

inherit
	EL_FIND_DIRECTORIES_COMMAND_I
		export
			{NONE} all
		undefine
			adjusted_lines, new_command_string
		end

	EL_FIND_COMMAND_IMP
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

	Template: STRING = "[
		dir /B
		
		#if $max_depth > 1 then
		/S
		#end
		
		/AD $path
	]"
end
