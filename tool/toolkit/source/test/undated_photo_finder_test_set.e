note
	description: "Test command class [$source UNDATED_PHOTO_FINDER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-11 13:59:03 GMT (Thursday 11th May 2023)"
	revision: "7"

class
	UNDATED_PHOTO_FINDER_TEST_SET

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
				["execute", agent test_execute]
			>>)
		end

feature -- Tests

	test_execute
		local
			finder: UNDATED_PHOTO_FINDER
			output_path, jpeg_path: FILE_PATH; undated_set: EL_HASH_SET [FILE_PATH]
			jpeg_info: EL_JPEG_FILE_INFO_COMMAND_I; dated_count: INTEGER
		do
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} jpeg_info.make_default
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