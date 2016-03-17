note
	description: "Summary description for {EL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-15 12:34:12 GMT (Tuesday 15th September 2015)"
	revision: "5"

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

	escaped_path (a_path: EL_PATH): ASTRING
		do
			Result := a_path.to_string
			if Result.has (' ') then
				Result.quote (2)
			end
		end

feature -- Constants

	Error_redirection_suffix: STRING = ""

end
