note
	description: "Counts the number of words in a HTML document"
	tests: "[$source HTML_BODY_WORD_COUNTER_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 6:06:50 GMT (Monday 7th February 2022)"
	revision: "15"

class
	HTML_BODY_WORD_COUNTER

inherit
	EL_FILE_TREE_COMMAND
		rename
			do_with_file as count_words
		export
			{EL_APPLICATION} make
		redefine
			execute
		end

	EL_MODULE_FILE
	
create
	make

feature -- Access

	Description: STRING = "Count words in directory of html body files (*.body)"

	word_count: INTEGER

feature -- Basic operations

	execute
		do
			word_count := 0
			Precursor
		end

feature {NONE} -- Implementation

	count_words (body_path: FILE_PATH)
		local
			xhtml: EL_XHTML_UTF_8_SOURCE; node_event_generator: EL_XML_NODE_EVENT_GENERATOR
			counter: EL_XHTML_WORD_COUNTER
		do
			create xhtml.make (File.plain_text (body_path))
			create counter
			create node_event_generator.make_with_handler (counter)
			node_event_generator.scan (xhtml.source)
			word_count := word_count + counter.count
		end

feature {NONE} -- Constants

	File_extensions: STRING = "body"

end