note
	description: "File sync constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 15:24:35 GMT (Friday 19th March 2021)"
	revision: "1"

class
	EL_FILE_SYNC_ROUTINES

feature {NONE} -- Implementation

	new_crc_name_dir (parent_dir: EL_DIR_PATH; a_name: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			Result := parent_dir.joined_dir_path (Crc_name_template #$ [a_name])
		end

feature {NONE} -- Constants

	Crc_extension: ZSTRING
		once
			Result := "crc"
		end

	Crc_name_template: ZSTRING
		once
			Result := ".%S-sync"
		end
		
	File_sync_item_type_id: INTEGER
		once
			Result := ({EL_FILE_SYNC_ITEM}).type_id
		end

end
