note
	description: "Persistent table mapping file paths to CRC-32 checksums"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-07 9:24:08 GMT (Friday 7th September 2018)"
	revision: "3"

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
		do
			create file.make_open_write (file_path)
			from start until after loop
				if file.count > 0 then
					file.put_new_line
				end
				file.put_natural (item_for_iteration)
				file.put_raw_string_8 (": ")
				file.put_string (key_for_iteration)
				forth
			end
			file.close
		end

feature -- Element change

	set_from_file (a_file_path: EL_FILE_PATH)
		local
			nvp: EL_NAME_VALUE_PAIR [ZSTRING]
		do
			file_path := a_file_path
			if file_path.exists then
				create nvp.make_empty
				across create {EL_FILE_LINE_SOURCE}.make (file_path) as line loop
					nvp.set_from_string (line.item, ':')
					extend (nvp.name.to_natural, nvp.value)
				end
			end
		end

feature -- Access

	file_path: EL_FILE_PATH
end
