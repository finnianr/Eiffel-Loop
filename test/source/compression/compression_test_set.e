note
	description: "Test-set for library [./library/compression.html compression.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 5:57:26 GMT (Monday 7th February 2022)"
	revision: "9"

class
	COMPRESSION_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

	EL_MODULE_FILE; EL_MODULE_ZLIB; EL_MODULE_LIO

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("archive_file", agent test_archive_file)
			eval.call ("zlib_compress", agent test_zlib_compress)
		end

feature -- Tests

	test_archive_file
		local
			archive: EL_COMPRESSED_ARCHIVE_FILE
			output_path: FILE_PATH; file_list: LIST [FILE_PATH]
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
				assert ("same data", decompressed_data ~ File.data (decompressed_list.item_path))
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

	source_dir: DIR_PATH
		do
			Result := EL_test_data_dir #+ "XML"
		end

	test_zlib_with_file (a_file_path: FILE_PATH)
			--
		local
			compressed_data, decompressed_data: SPECIAL [NATURAL_8]
			file_text: STRING; s: EL_STRING_8_ROUTINES
		do
			lio.put_path_field ("XML", a_file_path)
			file_text := File.plain_text (a_file_path)

			compressed_data := Zlib.compressed_string (file_text, 9, 0.3)
			lio.put_integer_field (" compressed by", (Zlib.last_compression_ratio * 100).rounded)
			lio.put_line ("%%")

			decompressed_data := Zlib.decompressed_bytes (compressed_data, file_text.count)

			assert ("Decompressed ok", file_text ~ s.from_code_array (decompressed_data))
		end

end