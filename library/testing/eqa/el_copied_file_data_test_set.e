note
	description: "Copied file data test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 14:04:29 GMT (Sunday 22nd December 2019)"
	revision: "2"

deferred class
	EL_COPIED_FILE_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

feature {NONE} -- Events

	on_prepare
		local
			relative_path: EL_FILE_PATH; relative_dir: EL_DIR_PATH
			list: like source_file_list
		do
			Precursor
			list := source_file_list
			create file_list.make_with_count (list.count)
			across list as path loop
				relative_path := Work_area_dir + path.item.relative_path (data_dir)
				relative_dir := relative_path.parent
				OS.File_system.make_directory (relative_dir)
				OS.copy_file (path.item, relative_dir)
				file_list.extend (relative_path)
			end
		end

feature {NONE} -- Implementation

	source_file_list: LIST [EL_FILE_PATH]
		deferred
		end

	data_dir: EL_DIR_PATH
		deferred
		end

feature {NONE} -- Internal attributes

	file_list: EL_FILE_PATH_LIST

end
