note
	description: "File data test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 14:01:19 GMT (Thursday 7th May 2020)"
	revision: "9"

deferred class
	EL_FILE_DATA_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_MODULE_OS

feature {NONE} -- Events

	on_clean
		do
			clean_work_area
		end

	on_prepare
		local
			l_dir: EL_DIRECTORY
		do
			Precursor
			create l_dir.make (Work_area_dir)
			if l_dir.exists and not l_dir.is_empty then
				l_dir.recursive_delete
			end
			if not l_dir.exists then
				l_dir.create_dir
			end
		end

feature {NONE} -- Implementation

	clean_work_area
		local
			l_dir: EL_DIRECTORY
		do
			create l_dir.make (Work_area_dir)
			l_dir.delete_content
		end

	has_changed (file_path: EL_FILE_PATH): BOOLEAN
		require
			file_checksums.has (file_path)
		do
			Result := file_checksums [file_path] /= OS.File_system.file_checksum (file_path)
		end

	store_checksum (file_path: EL_FILE_PATH)
		do
			file_checksums [file_path] := OS.File_system.file_checksum (file_path)
		end

feature {NONE} -- Constants

	File_checksums: EL_HASH_TABLE [NATURAL, EL_FILE_PATH]
		once
			create Result.make_equal (23)
		end

	Work_area_dir: EL_DIR_PATH
		once
			Result := "workarea"
		end

end
