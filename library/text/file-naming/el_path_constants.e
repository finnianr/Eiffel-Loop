note
	description: "Summary description for {EL_PATH_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PATH_CONSTANTS

feature -- Constants

	Invalid_NTFS_characters: ASTRING
		-- path characters that are invalid for a Windows NT file system
		once
			Result := Invalid_NTFS_characters_32
		end

	Invalid_NTFS_characters_32: STRING_32 = "/?<>\:*|%""

end
