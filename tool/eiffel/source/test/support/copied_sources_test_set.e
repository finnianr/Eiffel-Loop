﻿note
	description: "Test set that operates on Eiffel sources file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 17:36:31 GMT (Saturday 20th January 2024)"
	revision: "7"

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

	source_file_list: EL_FILE_PATH_LIST
		local
			files: like selected_files
			source_path: DIR_PATH
		do
			files := selected_files
			source_path := Sources_dir #+ Sources_sub_dir
			if files.is_empty then
				Result := OS.file_list (source_path, "*.e")
			else
				Result := OS.filtered_file_list (source_path, "*.e", Filter.base_name_in (files))
			end
		end

	selected_files: ARRAY [STRING]
		do
			create Result.make_empty
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

	has_latin_1_for_ano (line: STRING): BOOLEAN
		-- `True' for line
		-- 	string_literal ("año"),
		do
			Result := line.has_substring ("año")
		end

feature {NONE} -- Path constants

	Latin_1_sources_dir: DIR_PATH
		once
			Result := Sources_dir #+ "latin-1"
		end

	Sources_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

	Sources_sub_dir: DIR_PATH
		-- directory relative to `Sources_dir'
		once
			create Result
		end

	Manifest_path: FILE_PATH
		once
			Result := Work_area_dir + "manifest.pyx"
		end

	Utf_8_sources_dir: DIR_PATH
		once
			Result := Sources_dir #+ "utf-8"
		end

feature {NONE} -- Constants

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