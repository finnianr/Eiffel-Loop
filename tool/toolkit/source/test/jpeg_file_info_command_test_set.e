note
	description: "Test command class [$source UNDATED_PHOTO_FINDER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-18 11:56:11 GMT (Thursday 18th May 2023)"
	revision: "9"

class
	JPEG_FILE_INFO_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["undated_photo_finder", agent test_undated_photo_finder],
				["jpeg_info",				 agent test_jpeg_info]
			>>)
		end

feature -- Tests

	test_jpeg_info
		-- JPEG_FILE_INFO_COMMAND_TEST_SET.test_jpeg_info
		local
			jpeg_path: FILE_PATH; jpeg_info: EL_JPEG_FILE_INFO_COMMAND
			meta_data_count: INTEGER
		do
			create jpeg_info.make
			across file_list as path loop
				jpeg_path := path.item
				jpeg_info.set_file_path (jpeg_path)
				if jpeg_info.has_meta_data then
					lio.put_labeled_string ("File", jpeg_path.base)
					lio.put_new_line
					if jpeg_path.base_matches ("template276", False) then
						assert ("width OK", jpeg_info.image_width = 775)
						assert ("height OK", jpeg_info.image_height = 700)

					elseif jpeg_path.base_matches ("pulpit", False) then
						assert_same_string ("make OK", jpeg_info.device_make, "CASIO COMPUTER CO.,LTD")
						assert ("width OK", jpeg_info.image_width = 3072)
						assert ("height OK", jpeg_info.image_height = 2304)
					end
					meta_data_count := meta_data_count + 1
				end
			end
			assert ("2 have meta data", meta_data_count = 2)
		end

	test_undated_photo_finder
		local
			finder: UNDATED_PHOTO_FINDER
			output_path, jpeg_path: FILE_PATH; undated_set: EL_HASH_SET [FILE_PATH]
			jpeg_info: EL_JPEG_FILE_INFO_COMMAND; dated_count: INTEGER
		do
			create jpeg_info.make
			output_path := work_area_dir + "undated-photos.txt"
			create finder.make (work_area_dir, output_path)
			finder.execute
			create undated_set.make (20)
			across File.plain_text_lines (output_path) as line loop
				undated_set.put (line.item)
			end

			assert ("at least 30 undated", undated_set.count > 30)
			across file_list as path loop
				jpeg_path := path.item
				jpeg_info.set_file_path (jpeg_path)

				if undated_set.has (jpeg_path) then
					assert ("is not dated", not jpeg_info.has_date_time)
				else
					assert ("has EXIF date_time", jpeg_info.has_date_time)
					dated_count := dated_count + 1
				end
			end
			assert ("2 have EXIF date_time", dated_count = 2)
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_empty
			Result.append_sequence (OS.file_list (Data_dir, "*.jpg"))
		end

feature {NONE} -- Constants

	Contrib_library_dir: DIR_PATH
		once
			Result := Execution.variable_dir_path ("ISE_EIFFEL") #+ "contrib/library"
		end

	Data_dir: DIR_PATH
		once
			Result := Contrib_library_dir #+ "network/server/nino/example/SimpleWebServer/webroot"
		end

end