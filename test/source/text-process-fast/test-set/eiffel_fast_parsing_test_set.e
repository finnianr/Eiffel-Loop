note
	description: "Test parsing of Eiffel language expressions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-12 10:52:44 GMT (Saturday 12th November 2022)"
	revision: "2"

class
	EIFFEL_FAST_PARSING_TEST_SET

inherit
	EIFFEL_PARSING_TEST_SET
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
			writer: CODE_HIGHLIGHTING_WRITER_2; html_path: FILE_PATH
			xdoc: EL_XML_DOC_CONTEXT; xpath: STRING
		do
			assert ("source exists", file_list.count > 0)
			html_path := file_list.first_path.with_new_extension ("html")
			if attached open (html_path, Write) as html_out then
				html_out.set_encoding ({EL_ENCODING_CONSTANTS}.Latin_1)
				create writer.make (html_out)
				writer.set_file_path (file_list.first_path)
				writer.edit
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