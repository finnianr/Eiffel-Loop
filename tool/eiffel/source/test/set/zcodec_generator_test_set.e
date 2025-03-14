note
	description: "Test class ${ZCODEC_GENERATOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-08 11:55:18 GMT (Saturday 8th March 2025)"
	revision: "18"

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
				["latin_2",		  agent test_latin_2],
				["latin_6",		  agent test_latin_6],
				["latin_11",	  agent test_latin_11],
				["latin_15",	  agent test_latin_15],
				["windows_1252", agent test_windows_1252]
			>>)
		end

feature -- Tests

	test_latin_11
		do
			test_generation ("iso_8859_11", "cK50sRqB/ciRkZiYcmg60Q==")
		end

	test_latin_15
		do
			test_generation ("iso_8859_15", "Y50blKUlE1Wp5dYs1hp/TA==")
		end

	test_latin_2
		do
			test_generation ("iso_8859_2", "gVO308Qk18OBkyX25+hyAg==")
		end

	test_latin_6
		-- output for Latin-6 `latin_set_from_array' looks out of line in Gedit but is OK in EiffelStudio
		do
			test_generation ("iso_8859_6", "oGHuOFaMQ68OjHEA3trazg==")
		end

	test_windows_1252
		do
			test_generation ("windows_1252", "00jpaNkxyILGWOO7p9KzXg==")
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