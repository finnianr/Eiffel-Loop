note
	description: "Unix implementation of `EL_OS_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 9:58:51 GMT (Friday 24th June 2016)"
	revision: "1"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := a_path.to_string
			Result.escape (Path_escaper)
		end

	new_output_lines (file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
		do
			create Result.make (file_path)
		end

feature {NONE} -- Constants

	Command_prefix: STRING_32
		once
			create Result.make_empty
		end

	Path_escaper: EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER
		once
			create Result
		end

end