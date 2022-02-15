note
	description: "Path constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 5:56:11 GMT (Tuesday 15th February 2022)"
	revision: "14"

deferred class
	EL_PATH_CONSTANTS

inherit
	EL_SHARED_ZSTRING_CODEC

feature -- Constants

	Back_dir_step: ZSTRING
		once
			Result := "../"
		end

	Debug_template: ZSTRING
		once
			Result := "[%S] %S"
		end

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

	Invalid_NTFS_characters: ZSTRING
		-- path characters that are invalid for a Windows NT file system
		once
			create Result.make_from_general ("/?<>\:*|%"")
		end

	Separator: CHARACTER_32
		once
			Result := Operating_environment.Directory_separator
		end

	Unix_separator: CHARACTER_32 = '/'

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

	Windows_separator: CHARACTER_32 = '\'

end