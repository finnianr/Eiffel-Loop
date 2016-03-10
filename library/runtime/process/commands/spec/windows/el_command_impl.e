note
	description: "Summary description for {EL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 12:21:07 GMT (Friday 24th January 2014)"
	revision: "3"

deferred class
	EL_COMMAND_IMPL

inherit
	EL_PLATFORM_IMPL

feature -- Access

	template: STRING
			--
		deferred
		end

feature -- Basic operations

	adjust (command: EL_OS_COMMAND [EL_COMMAND_IMPL]; output_file_path: EL_FILE_PATH)
			-- Adjust output file contents for platform implementation
		do
		end

	new_output_lines (output_file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
		do
			create Result.make (output_file_path)
			Result.set_encoding (Result.Encoding_UTF, 8)
		end

feature -- Constants

	Path_escaper: EL_WINDOWS_PATH_CHARACTER_ESCAPER
		once
			create Result
		end

	Error_redirection_suffix: STRING = ""

end
