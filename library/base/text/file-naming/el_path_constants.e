note
	description: "Path constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-18 16:52:13 GMT (Thursday 18th February 2021)"
	revision: "8"

deferred class
	EL_PATH_CONSTANTS

inherit
	EL_SHARED_ZSTRING_CODEC

feature -- Constants

	Separator: CHARACTER_32
		once
			Result := Operating_environment.Directory_separator
		end

	Separator_z_code: NATURAL
		once
			Result := codec.as_z_code (Separator)
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