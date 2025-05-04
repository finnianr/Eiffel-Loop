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
	date: "2025-05-04 20:42:38 GMT (Sunday 4th May 2025)"
	revision: "13"

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
				covers/{EL_EIFFEL_SOURCE_ROUTINES}.class_parameter_list,
				covers/{EL_EIFFEL_SOURCE_ROUTINES}.class_name,
				covers/{EL_EXTENDED_READABLE_STRING_I}.matching_bracket_index
			]"
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES; type, parameter_1, parameter_2: TYPE [ANY]
		do
			type := {HASH_TABLE [LIST [INTEGER], STRING]}
			parameter_1 := {LIST [INTEGER]}
			parameter_2 := {STRING}
			assert_same_string (Void, eif.class_name (type.name), "HASH_TABLE")
			if attached eif.class_parameter_list (type.name) as parameter_list then
				if parameter_list.count = 2 then
					across parameter_list as list loop
						if attached type.name.substring (list.item_lower, list.item_upper) as parameter then
							inspect list.cursor_index
								when 1 then
									assert_same_string (Void, parameter, parameter_1.name)
								when 2 then
									assert_same_string (Void, parameter, parameter_2.name)
							end
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
			Result := eiffel_loop_dir #+ "tool/eiffel/test-data/sources/latin-1/os-command"
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