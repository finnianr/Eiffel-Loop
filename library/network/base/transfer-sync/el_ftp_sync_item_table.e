note
	description: "Persistent table mapping file paths to CRC-32 checksums"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-04 21:29:58 GMT (Monday 4th March 2019)"
	revision: "5"

class
	EL_FTP_SYNC_ITEM_TABLE

inherit
	EL_HASH_TABLE [NATURAL, EL_FILE_PATH]
		rename
			make as make_from_array
		end

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
			file: EL_PLAIN_TEXT_FILE
			map_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [EL_FILE_PATH, NATURAL]
		do
			create map_list.make_from_table (Current)
			map_list.sort (True)

			create file.make_open_write (file_path)
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

feature -- Element change

	set_from_file (a_file_path: EL_FILE_PATH)
		local
			nvp: EL_NAME_VALUE_PAIR [ZSTRING]; condition: BOOLEAN
			line_source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			file_path := a_file_path
			if file_path.exists then
				create nvp.make_empty
				create line_source.make (file_path)
				line_source.enable_shared_item
				across line_source as line loop
					nvp.set_from_string (line.item, ':')
					if nvp.value.ends_with_general ("youtube_video.html") then
						condition := true
					end
					extend (nvp.name.to_natural, nvp.value)
				end
			end
		end

feature -- Access

	file_path: EL_FILE_PATH
end
