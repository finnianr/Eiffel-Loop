note
	description: "Windows implementation of [$source EL_FIND_FILES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:30:03 GMT (Wednesday 21st February 2018)"
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
				+ ["file_pattern_path", agent: ZSTRING do Result := (dir_path + name_pattern).escaped end]
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
