note
	description: "Path constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-26 13:11:22 GMT (Thursday 26th September 2019)"
	revision: "7"

class
	EL_PATH_CONSTANTS

feature -- Constants

	Separator: CHARACTER_32
		once
			Result := Operating_environment.Directory_separator
		end

	Unix_separator: CHARACTER_32 = '/'

	Windows_separator: CHARACTER_32 = '\'

	Invalid_NTFS_characters: ZSTRING
		-- path characters that are invalid for a Windows NT file system
		once
			Result := Invalid_NTFS_characters_32
		end

	Invalid_NTFS_characters_32: STRING_32 = "/?<>\:*|%""

end
