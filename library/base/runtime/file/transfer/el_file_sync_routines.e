note
	description: "File sync constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_FILE_SYNC_ROUTINES

feature {NONE} -- Implementation

	new_crc_sync_dir (parent_dir: DIR_PATH; a_name: READABLE_STRING_GENERAL): DIR_PATH
		do
			Result := parent_dir #+ (Crc_name_prefix + a_name)
		end

feature {NONE} -- Constants

	Crc_extension: ZSTRING
		once
			Result := "crc"
		end

	Crc_name_prefix: ZSTRING
		once
			Result := ".sync-"
		end

	File_sync_item_type_id: INTEGER
		once
			Result := ({EL_FILE_SYNC_ITEM}).type_id
		end

end