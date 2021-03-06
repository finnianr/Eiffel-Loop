note
	description: "Test sets that read or write data to a temporary test directory `work_area_dir'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 16:48:30 GMT (Saturday 20th March 2021)"
	revision: "12"

deferred class
	EL_FILE_DATA_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

	EL_MODULE_DIGEST

	EL_MODULE_LIO

	EL_FILE_OPEN_ROUTINES

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

	check_same_content (file_path: EL_FILE_PATH; md5_digest: STRING)
		local
			md5: STRING; label: ZSTRING
		do
			md5 := Digest.md5_file (file_path).to_hex_string
			label := "MD5 SUM (%"%S%")"
			lio.put_labeled_string (label #$ [file_path.base], md5)
			lio.put_new_line
			assert ("same content", md5 ~ md5_digest)
		end

	work_area_path (a_path: EL_DIR_PATH): EL_DIR_PATH
		do
			Result := Work_area_dir.joined_dir_path (a_path)
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

	Work_area_absolute_dir: EL_DIR_PATH
		once
			Result := Directory.current_working #+ Work_area_dir
		end
end