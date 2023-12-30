note
	description: "Copied file data test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-30 16:14:21 GMT (Saturday 30th December 2023)"
	revision: "8"

deferred class
	EL_COPIED_FILE_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_SHARED_FIND_FILE_FILTER_FACTORY

feature {NONE} -- Events

	on_prepare
		local
			relative_path: FILE_PATH; relative_dir: DIR_PATH
			list: like source_file_list
		do
			Precursor
			list := source_file_list
			create file_list.make (list.count)
			across list as path loop
				relative_path := Work_area_dir + path.item.relative_path (data_dir)
				relative_dir := relative_path.parent
				OS.File_system.make_directory (relative_dir)
				OS.copy_file (path.item, relative_dir)
				file_list.extend (relative_path)
			end
		end

feature {NONE} -- Implementation

	source_file_list: LIST [FILE_PATH]
		deferred
		end

	data_dir: DIR_PATH
		deferred
		end

	new_file_digest_table: HASH_TABLE [EL_BYTE_ARRAY, FILE_PATH]
		do
			create Result.make (file_list.count)
			across file_list as list loop
				Result [list.item] := Digest.md5_plain_text (list.item)
			end
		end

feature {NONE} -- Internal attributes

	file_list: EL_FILE_PATH_LIST

end