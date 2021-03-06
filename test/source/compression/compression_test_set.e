note
	description: "Test-set for library [./library/compression.html compression.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 17:02:43 GMT (Saturday 20th March 2021)"
	revision: "3"

class
	COMPRESSION_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_ZLIB

	EL_MODULE_LIO

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("zlib_compress", agent test_zlib_compress)
			eval.call ("archive_file", agent test_archive_file)
		end

feature -- Tests

	test_archive_file
		local
			archive: EL_COMPRESSED_ARCHIVE_FILE
			output_path: EL_FILE_PATH; file_list: LIST [EL_FILE_PATH]
			decompressed_list: EL_DECOMPRESSED_DATA_LIST
			decompressed_data: MANAGED_POINTER
		do
			output_path := work_area_dir + "XML.archive"
			file_list := File_system.files (work_area_data_dir, True)
			create archive.make_open_write (output_path)

			archive.append_file_list (file_list)
			archive.close

			create decompressed_list.make (file_list.count)
			archive.open_read
			archive.decompress_all (decompressed_list)
			archive.close

			assert ("all files restored", decompressed_list.full)
			from decompressed_list.start until decompressed_list.after loop
				assert ("valid file path", file_list.has (decompressed_list.item_path))
				lio.put_path_field ("XML", decompressed_list.item_path)
				lio.put_new_line
				create decompressed_data.share_from_pointer (
					decompressed_list.item_data.base_address, decompressed_list.item_data.count
				)
				assert ("same data", decompressed_data ~ File_system.file_data (decompressed_list.item_path))
				decompressed_list.forth
			end
		end

	test_zlib_compress
		do
			across File_system.files (work_area_data_dir, True) as path loop
				test_zlib_with_file (path.item)
			end
		end

feature {NONE} -- Implementation

	test_zlib_with_file (a_file_path: EL_FILE_PATH)
			--
		local
			array: SPECIAL [NATURAL_8]
			file_data, compressed_data, uncompressed_data: MANAGED_POINTER
		do
			lio.put_path_field ("XML", a_file_path)
			lio.put_new_line
			file_data := File_system.file_data (a_file_path)

			array := Zlib.compress (file_data, 0.3, 9)
			create compressed_data.make_from_pointer (array.base_address, array.count)

			array := Zlib.uncompress (compressed_data, file_data.count)
			create uncompressed_data.share_from_pointer (array.base_address, array.count)

			assert ("Decompressed ok", file_data ~ uncompressed_data)
		end

	Source_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir #+ "XML"
		end

end