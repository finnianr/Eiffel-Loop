note
	description: "Summary description for {HTML_BODY_WORD_COUNTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 13:08:24 GMT (Sunday 20th December 2015)"
	revision: "5"

class
	HTML_BODY_WORD_COUNTER

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

create
	default_create, make

feature {EL_SUB_APPLICATION} -- Initialization

	make (a_html_body_dir: like html_body_dir)
		do
			html_body_dir := a_html_body_dir
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			File_system.file_list (html_body_dir, "*.body").do_all (agent count_words)
			log.exit
		end

feature {NONE} -- Implementation

	count_words (body_path: EL_FILE_PATH)
		local
			xhtml: EL_XHTML_UTF_8_SOURCE; xhtml_file: PLAIN_TEXT_FILE
			node_event_generator: EL_XML_NODE_EVENT_GENERATOR; counter: EL_XHTML_WORD_COUNTER
		do
			log.enter_with_args ("count_words", << body_path.to_string.to_utf_8 >>)
			create xhtml.make (File_system.plain_text (body_path))
			create counter
			create node_event_generator.make (counter)
			node_event_generator.scan (xhtml.source)
			log.put_integer_field ("Words", counter.count)

			create xhtml_file.make_open_write (body_path.with_new_extension ("xhtml"))
			xhtml_file.put_string (xhtml.source)
			xhtml_file.close
			log.exit
		end

	html_body_dir: EL_DIR_PATH
end
