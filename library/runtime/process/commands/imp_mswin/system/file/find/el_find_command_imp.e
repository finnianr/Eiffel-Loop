note
	description: "Windows implementation of [$source EL_FIND_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 7:49:06 GMT (Sunday 21st May 2023)"
	revision: "19"

deferred class
	EL_FIND_COMMAND_IMP

inherit
	EL_FIND_COMMAND_I
		export
			{NONE} all
		redefine
			get_escaped_path
		end

	EL_CAPTURED_OS_COMMAND_IMP
		export
			{NONE} all
		undefine
			get_escaped_path, getter_function_table, make_default, reset
		redefine
			new_output_lines
		end

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	get_escaped_path (field: EL_REFLECTED_PATH): ZSTRING
		do
			if name_pattern.is_empty then
				Result := Precursor (field)

			elseif attached {DIR_PATH} field.value (Current) as l_path and then l_path = dir_path then
				Result := (l_path #+ name_pattern).escaped
			else
				Result := Precursor (field)
			end
		end

	new_output_lines (file_path: FILE_PATH): EL_WINDOWS_FILE_PATH_LINE_SOURCE
		do
			create Result.make (Current, file_path)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		dir /B
		#if $max_depth > 1 then
			/S
		#end
		/A$type $dir_path
	]"

end