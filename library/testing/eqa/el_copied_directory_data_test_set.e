note
	description: "Test set that requires a directory of test data to be copied to `workarea' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-21 13:20:20 GMT (Monday 21st February 2022)"
	revision: "4"

deferred class
	EL_COPIED_DIRECTORY_DATA_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			OS.copy_tree (source_dir, work_area_dir)
			lio.put_new_line
			work_area_data_dir := work_area_dir.joined_dir_tuple ([source_dir.base])
		end

feature {NONE} -- Implementation

	file_path (relative_path: READABLE_STRING_GENERAL): FILE_PATH
		local
			path: FILE_PATH
		do
			create path.make (relative_path)
			Result := work_area_data_dir + path
		end

	source_dir: DIR_PATH
		deferred
		end

feature {NONE} -- Internal attributes

	work_area_data_dir: DIR_PATH
end