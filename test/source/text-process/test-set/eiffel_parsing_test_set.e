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
	date: "2022-11-22 7:16:52 GMT (Tuesday 22nd November 2022)"
	revision: "5"

class
	EIFFEL_PARSING_TEST_SET

inherit
	LEGACY_EIFFEL_PARSING_TEST_SET
		redefine
			test_code_highlighting
		end

feature -- Tests

	test_code_highlighting
		note
			testing: "covers/{EL_FILE_PARSER_TEXT_EDITOR}.edit",
				"covers/{XML_ROUTINES}.escaped_128_plus",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.comment",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.unescaped_manifest_string",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.character_manifest",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.identifier",
				"covers/{EL_EIFFEL_TEXT_PATTERN_FACTORY}.quoted_manifest_string"
		local
			writer: CODE_HIGHLIGHTING_WRITER; html_path: FILE_PATH
			xdoc: EL_XML_DOC_CONTEXT; xpath: STRING
		do
			assert ("source exists", file_list.count > 0)
			html_path := file_list.first_path.with_new_extension ("html")
			if attached open (html_path, Write) as html_out then
				html_out.set_encoding ({EL_ENCODING_CONSTANTS}.Latin_1)
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

end