note
	description: "Test class ${ZCODEC_GENERATOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-07 14:33:35 GMT (Wednesday 7th August 2024)"
	revision: "16"

class
	ZCODEC_GENERATOR_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["latin_15",	  agent test_latin_15],
				["latin_2",		  agent test_latin_2],
				["latin_6",		  agent test_latin_6],
				["latin_11",	  agent test_latin_11],
				["windows_1252", agent test_windows_1252]
			>>)
		end

feature -- Tests

	test_latin_2
		do
			test_generation ("iso_8859_2", "RB1gd+F48uqzx2e0F3vRNw==")
		end

	test_latin_6
		-- output for Latin-6 `latin_set_from_array' looks out of line in Gedit but is OK in EiffelStudio
		do
			test_generation ("iso_8859_6", "BmBcvVLeH86Q5D6vfij2AA==")
		end

	test_latin_11
		do
			test_generation ("iso_8859_11", "NFiG8WgKl9ainRRRAu8++g==")
		end

	test_latin_15
		do
			test_generation ("iso_8859_15", "doydvWojUnQQv4JzWH48rA==")
		end

	test_windows_1252
		do
			test_generation ("windows_1252", "hnYwVPiuocSSQaGbu5arpg==")
		end

feature {NONE} -- Implementation

	test_generation (selected_codec, expected_digest: STRING)
		local
			command: ZCODEC_GENERATOR; count, id: INTEGER; s: EL_STRING_8_ROUTINES
			source_path: FILE_PATH
		do
			create command.make ("test-data/sources/C/decoder.c", "doc/zcodec/template.evol")
			command.set_selected_codec (selected_codec)
			command.execute
			lio.put_new_line
			id := s.substring_to_reversed (selected_codec, '_').to_integer
			source_path := Work_area_dir + Base_name_template #$ [selected_codec]
			if source_path.exists then
				lio.put_integer_field ("Comparing content digest for id", id)
				lio.put_new_line
				assert ("has BOM", File.has_utf_8_bom (source_path))
				assert_same_digest (Plain_text, source_path, expected_digest)
				count := count + 1
			else
				failed (source_path.to_string + " exists")
			end
		end

feature {NONE} -- Constants

	Base_name_template: ZSTRING
		once
			Result := "el_%S_zcodec.e"
		end

end