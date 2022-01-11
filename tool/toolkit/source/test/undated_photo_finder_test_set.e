note
	description: "Test command class [$source UNDATED_PHOTO_FINDER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-11 19:57:04 GMT (Tuesday 11th January 2022)"
	revision: "1"

class
	UNDATED_PHOTO_FINDER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_COMMAND

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("execute", agent test_execute)
		end

feature -- Tests

	test_execute
		local
			finder: UNDATED_PHOTO_FINDER
			output_path: FILE_PATH
			undated_set: EL_HASH_SET [FILE_PATH]
			jpeg_info: like command.new_jpeg_info
			dated_count: INTEGER
		do
			jpeg_info := Command.new_jpeg_info ("")
			output_path := work_area_dir + "undated-photos.txt"
			create finder.make (work_area_dir, output_path)
			finder.execute
			create undated_set.make (20)
			across File_system.plain_text_lines (output_path) as line loop
				undated_set.put (line.item)
			end

			assert ("at least 30 undated", undated_set.count > 30)
			across file_list as path loop
				if not undated_set.has (path.item) then
					jpeg_info.set_file_path (path.item)
					assert ("is pulpit.jpg", jpeg_info.has_date_time and then path.item.base.same_string ("pulpit.jpg"))
					dated_count := dated_count + 1
				end
			end
			assert ("1 dated", dated_count = 1)
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_empty
			across ("jpeg,jpg").split (',') as extension loop
				Result.append_sequence (OS.file_list (Data_dir, "*." + extension.item))
			end
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