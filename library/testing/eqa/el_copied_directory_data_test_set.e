note
	description: "Test set that requires a directory of test data to be copied to `workarea' directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 16:24:04 GMT (Sunday 4th May 2025)"
	revision: "10"

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
			work_area_data_dir := work_area_dir.twin
			work_area_data_dir.append_step (source_dir.base)
		end

feature {NONE} -- Implementation

	file_path (relative_path: READABLE_STRING_GENERAL): FILE_PATH
		local
			path: FILE_PATH
		do
			create path.make (relative_path)
			Result := work_area_data_dir.plus_file (path)
		end

	file_path_abs (relative_path: READABLE_STRING_GENERAL): FILE_PATH
		do
			Result := Directory.current_working.plus_file (file_path (relative_path))
		end

	new_file_list (a_file_pattern: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
		do
			Result := OS.file_list (work_area_data_dir, a_file_pattern)
		end

	source_dir: DIR_PATH
		deferred
		end

feature {NONE} -- Internal attributes

	work_area_data_dir: DIR_PATH

feature {NONE} -- Constants

	Any_file: STRING = "*"
end