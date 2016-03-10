note
	description: "Summary description for {EL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

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

end
