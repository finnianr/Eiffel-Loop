note
	description: "Standard argument names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 11:52:51 GMT (Friday 25th January 2019)"
	revision: "2"

class
	EL_COMMAND_ARGUMENT_CONSTANTS

feature {NONE} -- Constants

	Eng_directory: ZSTRING
		once
			Result := "directory"
		end

	Eng_file: ZSTRING
		once
			Result := "file"
		end

	Input_path_option_name: STRING
			--
		once
			Result := "file"
		end

end
