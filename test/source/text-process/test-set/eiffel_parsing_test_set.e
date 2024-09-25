note
	description: "Test parsing of Eiffel language expressions"
	notes: "[
		**Performance Comparison**
		
			Class: EIFFEL_LEGACY_PARSING_TEST_SET
			Executing test: code_highlighting
			TIME: 0 secs 18 ms
		
			Class: EIFFEL_PARSING_TEST_SET
			Executing test: code_highlighting
			TIME: 0 secs 6 ms
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 12:27:45 GMT (Monday 23rd September 2024)"
	revision: "11"

class
	EIFFEL_PARSING_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["code_highlighting", agent test_code_highlighting],
				["parameter_parsing", agent test_parameter_parsing]
			>>)
		end

feature -- Tests

	test_code_highlighting
		note
			testing: "[
				covers/{EL_FILE_PARSER_TEXT_EDITOR}.edit,
				covers/{XML_ROUTINES}.escaped_128_plus,
				covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.comment,
				covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.unescaped_manifest_string,
				covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.character_manifest,
				covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.identifier,
				covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.quoted_manifest_string
			]"
		local
			writer: CODE_HIGHLIGHTING_WRITER; html_path: FILE_PATH
			xdoc: EL_XML_DOC_CONTEXT; xpath: STRING
		do
			assert ("source exists", file_list.count > 0)
			html_path := file_list.first_path.with_new_extension ("html")
			if attached open (html_path, Write) as html_out then
				html_out.set_encoding ({EL_ENCODING_TYPE}.Latin_1)
				create writer.make (html_out)
				writer.set_file_path (file_list.first_path)
				lio.set_timer
				writer.edit
				lio.put_elapsed_time
			end
			create xdoc.make_from_file (html_path)

			across Emphasis_counts as count loop
				xpath := Xpath_count_template #$ [count.key]
				lio.put_labeled_string ("check xpath", xpath)
				lio.put_new_line
				assert ("same count " + count.key, xdoc.query (xpath).as_integer = count.item)
			end
		end

	test_parameter_parsing
		-- EIFFEL_PARSING_TEST_SET.test_parameter_parsing
		note
			testing: "[
				covers/{EL_EIFFEL_SOURCE_ROUTINES}.class_parameter_list
			]"
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES; type, parameter: STRING
		do
			type := "HASH_TABLE [INTEGER, STRING]"
			if attached eif.class_parameter_list (type) as parameter_list then
				if parameter_list.count = 2 then
					across parameter_list as list loop
						parameter := type.substring (list.item_lower, list.item_upper)
						inspect list.cursor_index
							when 1 then
								assert_same_string (Void, parameter, "INTEGER")
							when 2 then
								assert_same_string (Void, parameter, "STRING")
						end
					end
				else
					failed ("has 2 parameters")
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "el_mp3_convert_command.e" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "tool/eiffel/test-data/sources/latin-1/os-command"
		end

	Emphasis_counts: EL_HASH_TABLE [INTEGER, STRING]
		once
			Result := <<
				["quote", 13], ["class", 21], ["comment",	13], ["keyword", 7]
			>>
		end

	Xpath_count_template: ZSTRING
		once
			Result := "count (//em[@id='%S'])"
		end
end