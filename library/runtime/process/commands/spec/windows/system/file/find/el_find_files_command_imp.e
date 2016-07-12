note
	description: "Windows implementation of `EL_FIND_FILES_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 13:18:13 GMT (Monday 20th June 2016)"
	revision: "4"

class
	EL_FIND_FILES_COMMAND_IMP

inherit
	EL_FIND_FILES_COMMAND_I
		export
			{NONE} all
		undefine
			make_default,
			adjusted_lines, new_command_string, getter_function_table
		redefine
			getter_function_table
		end

	EL_FIND_COMMAND_IMP
		rename
			make as make_path
		undefine
			getter_function_table
		end

create
	make, make_default

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_FIND_FILES_COMMAND_I}
			Result.append_tuples (<<
				["file_pattern_path", agent: ZSTRING do Result := escaped_path (dir_path + name_pattern) end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		dir /B
		
		#if $max_depth > 1 then
			/S
		#end
		
		/A-D $file_pattern_path
	]"
end
