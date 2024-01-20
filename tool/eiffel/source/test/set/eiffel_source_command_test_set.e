note
	description: "Test commands conforming to ${SOURCE_MANIFEST_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:19:33 GMT (Saturday 20th January 2024)"
	revision: "27"

class
	EIFFEL_SOURCE_COMMAND_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		redefine
			make
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["class_analyzer",					agent test_class_analyzer],
				["class_note_link_reformatting",	agent test_class_note_link_reformatting],
				["class_reader",						agent test_class_reader],
				["code_metrics",						agent test_code_metrics],
				["find_and_replace",					agent test_find_and_replace],
				["space_cleaner",						agent test_space_cleaner]
			>>)
		end

feature -- Tests

	test_class_analyzer
		note
			testing: "[
				covers/{EIFFEL_SOURCE_ANALYZER}.make
			]"
		local
			analyzer: EIFFEL_SOURCE_ANALYZER
		do
			create analyzer.make_from_file (Latin_1_sources_dir + "parse/thunderbird_mail_to_html_body_converter.e")
			assert ("249 identifiers", analyzer.identifier_count = 249)
			assert ("81 keywords", analyzer.keyword_count = 81)
		end

	test_class_note_link_reformatting
		-- EIFFEL_SOURCE_COMMAND_TEST_SET.test_class_note_link_reformatting
		note
			testing: "[
				covers/{EIFFEL_SOURCE_ANALYZER}.make
			]"
		local
			command: CLASS_NOTE_LINK_REFORMATTING_COMMAND
		do
			create command.make (Manifest_path)
			command.execute
			assert ("2 class updated", command.updated_count = 2)
			across <<
				"latin-1/audio/el_8_bit_audio_pcm_sample.e", "utf-8/el_text_item_translations_table.e"
			>> as path loop
				if attached File.plain_text (Work_area_dir + path.item) as source then
					inspect path.cursor_index
						when 1 then
							assert ("updated", source.has_substring ("${EL_AUDIO_PCM_SAMPLE}"))
						when 2 then
							assert ("has BOM", source.starts_with ({EL_UTF_CONVERTER}.utf_8_bom_to_string_8))
							assert ("updated", source.has_substring ("${HASH_TABLE [STRING, STRING]}"))
					end
				end
			end
		end

	test_class_reader
		note
			testing: "[
				covers/{EIFFEL_SOURCE_READER}.make
			]"
		local
			reader: TEST_SOURCE_READER; hexadecimal_count, integer_count: INTEGER
			number: STRING; char_string: ZSTRING
		do
			create reader.make_from_file (Utf_8_sources_dir + "test_el_astring.e")
			assert_same_string ("parsed percent character '%%'", reader.quoted_character_list [2], "%%%%")

			create reader.make_from_file (Latin_1_sources_dir + "os-command/file-system/EL_FIND_OS_COMMAND.e")
			assert ("7 items", reader.operator_list.count = 7)
			assert_same_string ("5th is and", reader.operator_list [5], "and")

			create reader.make_from_file (Utf_8_sources_dir + "el_iso_8859_10_codec.e")
			assert ("101 comments", reader.comment_list.count = 101)
			assert_same_string ("Access comment", reader.comment_list.first, "-- Access")

			if attached reader.numeric_constant_list as numeric_list then
				assert ("161 numeric constants", numeric_list.count = 161)
				assert_same_string ("first number", numeric_list.first, "10")
				assert_same_string ("last number", numeric_list.last, "0xFF")

				across reader.numeric_constant_list as list loop
					number := list.item
					if number.is_natural then
						integer_count := integer_count + 1

					elseif number.starts_with ("0x") then
						hexadecimal_count := hexadecimal_count + 1
					end
				end
			end
			assert ("total numbers is 161", integer_count + hexadecimal_count = 161)

			if attached reader.keyword_list as keyword_list then
				assert ("total keywords is 169", keyword_list.count = 169)
				assert_same_string ("first keyword", keyword_list.first, "note")
				assert_same_string ("last keyword", keyword_list.last, "end")
			end
			if attached reader.identifier_list as identifier_list then
				assert ("total identifiers is 59", identifier_list.count = 59)
				assert_same_string ("first identifier", identifier_list.first, "description")
				assert_same_string ("last identifier", identifier_list.last, "single_byte_unicode_chars")
			end
			if attached reader.quoted_character_list as quoted_character_list then
				assert ("total quoted characters is 95", quoted_character_list.count = 95)
				across << quoted_character_list.first, quoted_character_list.last >> as str loop
					create char_string.make_from_utf_8 (str.item)
					if char_string.count = 1 then
						inspect str.cursor_index
							when 1 then
								assert ("is NBSP", char_string [1].natural_32_code = 0xA0)

							when 2 then
								assert ("Greenlandic Kra", char_string [1] = 'ĸ')
						else
						end
					else
						failed ("Is a single character")
					end
				end
			end
		end

	test_code_metrics
		-- EIFFEL_SOURCE_COMMAND_TEST_SET.test_code_metrics
		local
			command: MANIFEST_METRICS_COMMAND; assertion_template: ZSTRING
			actual_results, expected_results: EL_ARRAYED_LIST [INTEGER]
		do
			create command.make (Manifest_path)
			command.execute
			create expected_results.make_from_array (<< 32, 279, 99772 >>)
			if attached command.metrics as metrics then
				create actual_results.make_from_array (<< metrics.class_count, metrics.routine_count, metrics.byte_count >>)
			end
			assertion_template := "%S classes %S routines. Total size %S bytes"

			if expected_results /~ actual_results then
				lio.put_labeled_string ("Actual", assertion_template #$ actual_results.to_tuple)
				lio.put_new_line
				lio.put_labeled_string ("Expected", assertion_template #$ expected_results.to_tuple)
				lio.put_new_line
				failed ("same class count, routine count etc")
			end
		end

	test_find_and_replace
		-- EIFFEL_SOURCE_COMMAND_TEST_SET.test_find_and_replace
		local
			command: FIND_AND_REPLACE_COMMAND; replace_count, sample_count: INTEGER
			plain_text_lines: like File.plain_text_lines
		do
			create command.make (Manifest_path, "INTEGER =", Integer_32_type)
			command.execute
			across file_list as list loop
				plain_text_lines := File.plain_text_lines (list.item)
				if plain_text_lines.target.has_substring (Integer_32_type) then
					across plain_text_lines as line loop
						replace_count := replace_count + line.item.has_substring (Integer_32_type).to_integer
					end
				end
				if across Encoding_sample_list as sample some sample.item ~ list.item.base end then
					assert ("has replacement", File.plain_text (list.item).has_substring (Integer_32_type))
					sample_count := sample_count + 1
				end
			end
		-- job_duration_parser.e is in both "feature-edits" and  "latin-1/parse"
			assert ("both samples replaced", sample_count = 3)
			assert ("24 replacements", replace_count = 24)
			assert_valid_encodings
		end

	test_space_cleaner
		-- EIFFEL_SOURCE_COMMAND_TEST_SET.test_space_cleaner
		local
			cleaner: SOURCE_LEADING_SPACE_CLEANER
		do
			create cleaner.make (Manifest_path)
			cleaner.execute
			assert ("expect edition count", cleaner.edited_list.count = Cleaned_file_table.count)
			across cleaner.edited_list as list loop
				assert_same_digest (Plain_text, list.item, Cleaned_file_table [list.item.base_name])
			end
		end

feature {NONE} -- Implementation

	list_has (list: ARRAYED_LIST [IMMUTABLE_STRING_8]; str: STRING): BOOLEAN
		do
			Immutable_8.set_item (str.area, 0, str.count)
			Result := list.has (Immutable_8.item)
		end

feature {NONE} -- Constants

	Cleaned_file_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["ev_pixmap_imp_drawable",	"BGfhfW0ucYUTtNmjtmbBPQ=="],
				["el_x11_extensions_api",	"K1NL9HUytsKAAorC63jBiA=="]
			>>)
		end

	Integer_32_type: STRING = "INTEGER_32 ="

end