note
	description: "Persistent table mapping file paths to CRC-32 checksums"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-17 14:06:36 GMT (Sunday 17th January 2021)"
	revision: "10"

class
	EL_FTP_SYNC_ITEM_TABLE

inherit
	EL_HASH_TABLE [NATURAL_32, EL_FILE_PATH]
		rename
			make as make_from_array
		end

	EL_FILE_OPEN_ROUTINES

create
	make

feature {NONE} -- Initialization

	make
		do
			create file_path
			make_equal (100)
		end

feature -- Basic operations

	save
		require
			file_path_set: not file_path.is_empty
		local
			map_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [EL_FILE_PATH, NATURAL_32]
		do
			create map_list.make_from_table (Current)
			map_list.sort (True)

			if attached open (file_path, Write) as file then
				from map_list.start until map_list.after loop
					if file.count > 0 then
						file.put_new_line
					end
					file.put_natural (map_list.item_value)
					file.put_raw_string_8 (": ")
					file.put_string (map_list.item_key)
					map_list.forth
				end
				file.close
			end
		end

feature -- Element change

	set_from_file (a_file_path: EL_FILE_PATH)
		local
			nvp: EL_NAME_VALUE_PAIR [ZSTRING]; line_source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			file_path := a_file_path
			if file_path.exists then
				create nvp.make_empty
				create line_source.make_utf_8 (file_path)
				line_source.enable_shared_item
				across line_source as line loop
					nvp.set_from_string (line.item, ':')
					extend (nvp.name.to_natural, nvp.value)
				end
			end
		end

feature -- Access

	file_path: EL_FILE_PATH
end