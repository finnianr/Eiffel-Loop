note
	description: "Test sets that read or write data to a temporary test directory `work_area_dir'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 16:26:11 GMT (Monday 1st January 2024)"
	revision: "25"

deferred class
	EL_FILE_DATA_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_DIGEST

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Events

	on_clean
		do
			clean_work_area
			Precursor
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

feature {NONE} -- Assertions

	assert_same_digest (type: NATURAL_8; file_path: FILE_PATH; md5_target: STRING)
		-- assert plaintext from `file_path' has `md5_target' digest expressed as base-64 string
		require
			valid_type: type = Raw_data or type = Plain_text
		local
			actual_digest: STRING
		do
			actual_digest := new_md5_array (type, file_path).to_base_64_string
			assert_same_md5_digest_strings (file_path.base, actual_digest, md5_target)
		end

	assert_same_digest_hexadecimal (type: NATURAL_8; file_path: FILE_PATH; md5_target: STRING)
		-- assert plaintext from `file_path' has `md5_target' digest expressed as hexadecimal string
		require
			valid_type: type = Raw_data or type = Plain_text
		local
			actual_digest: STRING
		do
			actual_digest := new_md5_array (type, file_path).to_hex_string
			assert_same_md5_digest_strings (file_path.base, actual_digest, md5_target)
		end

	assert_same_md5_digest (a_name: detachable READABLE_STRING_GENERAL; md5_actual: EL_MD5_128; target: STRING)
		do
			assert_same_md5_digest_strings (a_name, md5_actual.digest_base_64, target)
		end

	assert_same_md5_digest_strings (a_name: detachable READABLE_STRING_GENERAL; actual, target: STRING)
		-- assert plaintext from `file_path' has `md5_target' digest
		local
			message: STRING
		do
			if actual /~ target then
				message := "MD5 digests differ"
				if attached a_name as name then
					lio.put_labeled_string (name, message)
					lio.put_new_line
				else
					lio.put_line (message)
				end
				lio.put_string_field ("Actual", actual); lio.put_string_field (" Target", target)
				lio.put_new_line
				assert ("same digest", False)
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

	new_md5_array (type: NATURAL_8; file_path: FILE_PATH): EL_DIGEST_ARRAY
		require
			valid_type: type = Raw_data or type = Plain_text
		do
			inspect type
				when Plain_text then
					Result := Digest.md5_plain_text (file_path)
			else
				Result := Digest.md5_raw_data (file_path)
			end
		end

	work_area_path (a_path: DIR_PATH): DIR_PATH
		do
			Result := Work_area_dir #+ a_path
		end

	has_changed (file_path: FILE_PATH): BOOLEAN
		require
			file_checksums.has (file_path)
		do
			Result := file_checksums [file_path] /= File.checksum (file_path)
		end

	store_checksum (file_path: FILE_PATH)
		do
			file_checksums [file_path] := File.checksum (file_path)
		end

feature {NONE} -- Constants

	File_checksums: EL_HASH_TABLE [NATURAL, FILE_PATH]
		once
			create Result.make_equal (23)
		end

	Work_area_dir: DIR_PATH
		once
			Result := "workarea"
		end

	Work_area_absolute_dir: DIR_PATH
		once
			Result := Directory.current_working #+ Work_area_dir
		end

	Raw_data: NATURAL_8 = 1

	Plain_text: NATURAL_8 = 2
end