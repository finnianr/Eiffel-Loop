note
	description: "Test set that operates on Eiffel sources file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 7:55:53 GMT (Sunday 6th October 2024)"
	revision: "10"

deferred class
	COPIED_SOURCES_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			Data_dir as Sources_dir
		redefine
			on_prepare
		end

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_TUPLE

feature {NONE} -- Events

	on_prepare
		local
			l_file: PLAIN_TEXT_FILE
		do
			Precursor
			if not attached Execution_environment.item (Var_working_directory) then
				Execution_environment.put (Directory.current_working.as_string_32, Var_working_directory)
			end
			create l_file.make_open_write (Manifest_path)
			l_file.put_string (Source_manifest)
			l_file.close
		end

feature {NONE} -- Implementation

	assert_valid_encodings
		-- Make sure encoding samples are written correctly
		do
			across file_list as path loop
				if path.item.base ~ Encoding_sample.utf_8 then
					assert ("correct utf-8 for 0xA1",
						across File.plain_text_lines (path.item) as line some
							has_utf_8_for_0xA1 (line.item)
						end
					)
				elseif path.item.base ~ Encoding_sample.latin_1 then
					assert ("correct latin-1 for año",
						across File.plain_text_lines (path.item) as line some
							has_latin_1_for_ano (line.item)
						end
					)
				end
			end
		end

	has_latin_1_for_ano (line: STRING): BOOLEAN
		-- `True' for line
		-- 	string_literal ("año"),
		do
			Result := line.has_substring ("año")
		end

	has_utf_8_for_0xA1 (line: STRING): BOOLEAN
		-- `True' for line
		-- 	Result [0xA1] := 'Ą' --
		local
			zstr: ZSTRING
		do
			if line.has_substring ("0xA1") then
				create zstr.make_from_utf_8 (line)
				Result := zstr.has ('Ą')
			end
		end

	no_selected_files: ARRAY [STRING]
		do
			create Result.make_empty
		end

	source_file_list: EL_FILE_PATH_LIST
		local
			new_file_list: FUNCTION [DIR_PATH, EL_FILE_PATH_LIST]
		do
			create Result.make (50)
			if attached selected_files as files and then files.count > 0 then
				new_file_list := agent OS.filtered_file_list (?, Filter.base_name_in (files), Star_dot_e)
			else
				new_file_list := agent OS.file_list (?, Star_dot_e)
			end
			across sources_list as list loop
				Result.append (new_file_list (list.item))
			end
		end

feature -- Deferred

	selected_files: ARRAY [STRING]
		deferred
		end

	sources_list: ARRAY [DIR_PATH]
		deferred
		end

feature {NONE} -- Path constants

	Manifest_path: FILE_PATH
		once
			Result := Work_area_dir + "manifest.pyx"
		end

	Sources_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

	Source: TUPLE [feature_edits_dir, latin_1_dir, utf_8_dir: DIR_PATH]
		once
			create Result
			across ("feature-edits, latin-1, utf-8").split (',') as name loop
				name.item.left_adjust
				Result.put_reference (Sources_dir #+ name.item, name.cursor_index)
			end
		end

feature {NONE} -- Constants

	Star_dot_e: STRING = "*.e"

	Encoding_sample: TUPLE [utf_8, latin_1: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "el_iso_8859_10_codec.e, job_duration_parser.e")
		end

	Encoding_sample_list: EL_ZSTRING_LIST
		once
			create Result.make_from_tuple (Encoding_sample)
		end

	Source_manifest: STRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "ISO-8859-15"
				manifest:
					notes:
						author = "Finnian Reilly"
						copyright = "Copyright (c) 2001-2017 Finnian Reilly"
						contact = "finnian at eiffel hyphen loop dot com"
						license = "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
					location:
						"$PWD/workarea"
			]"
		end

	Var_working_directory: STRING = "PWD"

end