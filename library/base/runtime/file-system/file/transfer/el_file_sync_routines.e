note
	description: "File sync constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-27 7:26:12 GMT (Saturday 27th March 2021)"
	revision: "3"

class
	EL_FILE_SYNC_ROUTINES

feature {NONE} -- Implementation

	new_crc_sync_dir (parent_dir: EL_DIR_PATH; a_name: READABLE_STRING_GENERAL): EL_DIR_PATH
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