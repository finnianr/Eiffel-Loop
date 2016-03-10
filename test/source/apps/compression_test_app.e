note
	description: "Summary description for {COMPRESSION_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:53:19 GMT (Thursday 1st January 2015)"
	revision: "4"

class
	COMPRESSION_TEST_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_ZLIB

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_all_files_test ({STRING_32} "XML", All_routines, agent compress_file, 4254881218)
			Test.do_file_tree_test ({STRING_32} "XML", agent compress_files, 2040034646)
		end

feature -- Tests

	compress_file (a_file_path: EL_FILE_PATH)
			--
		local
			text: STRING
			file_data, compressed_data, uncompressed_data: MANAGED_POINTER
		do
			log.enter_with_args ("compress_file", << a_file_path >>)
			file_data := File_system.file_data (a_file_path)

			text := Zlib.compress (file_data, 0.3, 9)
			create compressed_data.make_from_pointer (text.area.base_address, text.count)

			text := Zlib.uncompress (compressed_data, text.count)
			create uncompressed_data.make_from_pointer (text.area.base_address, text.count)

			if file_data ~ uncompressed_data then
				log.put_string ("Decompressed ok")
				log.put_new_line
			else
				log.put_line ("Error")
			end
			log.exit
		end

	compress_files (a_dir_path: EL_DIR_PATH)
			--
		local
			compressed_file: EL_COMPRESSED_ARCHIVE_FILE
			output_path: EL_FILE_PATH
			file_list: LIST [EL_FILE_PATH]
		do
			log.enter_with_args ("compress_files", << a_dir_path >>)
			output_path := a_dir_path + "xml_files.z"
			file_list := File_system.file_list (a_dir_path, All_routines)
			create compressed_file.make_open_write (output_path)

			from file_list.start until file_list.after loop
				compressed_file.append_file (file_list.item, 0.5, 9)
				file_list.forth
			end
			compressed_file.close

			create compressed_file.make_open_read (output_path)
			from file_list.start until file_list.after loop
				compressed_file.read_compressed_file
				if compressed_file.last_string ~ File_system.plain_text (file_list.item) then
					log.put_string_field ("Uncompressed ok", compressed_file.last_file_path.to_string)
					log.put_new_line
				end
				file_list.forth
			end
			log.exit
		end

feature {NONE} -- Constants

	Option_name: STRING
			--
		once
			Result := "test_compression"
		end

	Description: STRING = "Test zlib compression"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{COMPRESSION_TEST_APP}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines]
			>>
		end

end
