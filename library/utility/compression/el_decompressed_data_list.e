note
	description: "Decompressed data list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_DECOMPRESSED_DATA_LIST

inherit
	EL_ARRAYED_MAP_LIST [FILE_PATH, SPECIAL [NATURAL_8]]
		rename
			item_key as item_path,
			item_value as item_data
		end

	EL_FILE_DECOMPRESS_HANDLER
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Event handling

	on_decompressed (archive: EL_COMPRESSED_ARCHIVE_FILE; a_index: INTEGER)
		do
			extend (archive.last_file_path, archive.last_data)
		end

	on_decompression_error (file_path: FILE_PATH; checksums_differ: BOOLEAN)
		do
		end

	on_unreadable_file_path
		do
		end
end