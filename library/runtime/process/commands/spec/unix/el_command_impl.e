note
	description: "Summary description for {EL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-22 19:21:12 GMT (Tuesday 22nd December 2015)"
	revision: "5"

deferred class
	EL_COMMAND_IMPL

inherit
	EL_PLATFORM_IMPL

feature -- Access

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

	new_output_lines (output_file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
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

	Error_redirection_suffix: ZSTRING
		once
			Result := " 2>&1"
		end

end
