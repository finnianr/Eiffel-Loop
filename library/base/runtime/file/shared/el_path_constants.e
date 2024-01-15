note
	description: "Path constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 9:42:41 GMT (Monday 15th January 2024)"
	revision: "18"

deferred class
	EL_PATH_CONSTANTS

inherit
	EL_SHARED_ZSTRING_CODEC

feature -- Strings

	Back_dir_step: ZSTRING
		once
			Result := "../"
		end

	Debug_template: ZSTRING
		once
			Result := "[%S] %S"
		end

	Empty_path: ZSTRING
		once
			create Result.make_empty
		end

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

	Square_brackets: STRING_32
		once
			Result := "[] "
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

feature -- Characters

	Separator: CHARACTER_32
		-- Character used to separate subdirectories in a path name on this platform.
		once
			Result := Operating_environment.Directory_separator
		end

	Unix_separator: CHARACTER_32 = '/'

	Windows_separator: CHARACTER_32 = '\'

feature {NONE} -- Constants

	URI_path_string: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end
end