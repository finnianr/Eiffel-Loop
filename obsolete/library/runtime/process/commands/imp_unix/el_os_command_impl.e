note
	description: "Summary description for {EL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-13 16:22:33 GMT (Monday 13th June 2016)"
	revision: "1"

deferred class
	EL_OS_COMMAND_IMPL

inherit
	EL_OS_COMMAND_INTERFACE

	EL_OS_IMPLEMENTATION

feature -- Access

	new_output_lines: EL_FILE_LINE_SOURCE
		do
			create Result.make (output_file_path)
			Result.set_encoding (Result.Encoding_UTF, 8)
		end

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := a_path.to_string
			Result.escape (Path_escaper)
		end

feature -- Constants

	Path_escaper: EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER
		once
			create Result
		end

	Error_redirection_suffix: STRING
		once
			Result := " 2>&1"
		end

end
