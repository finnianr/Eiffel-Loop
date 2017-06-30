note
	description: "Summary description for {EIFFEL_NOTE_HTML_TEXT_ELEMENT_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:30:26 GMT (Thursday 29th June 2017)"
	revision: "3"

class
	NOTE_HTML_TEXT_ELEMENT_LIST

inherit
	HTML_TEXT_ELEMENT_LIST
		rename
			make as make_list
		redefine
			Markdown, html_description
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (markdown_lines: EL_ZSTRING_LIST; a_relative_page_dir: like relative_page_dir)
		do
			relative_page_dir := a_relative_page_dir
			make_list (markdown_lines)
		end

feature {NONE} -- Implementation

	html_description: ZSTRING
			-- escaped description with html formatting
		do
			Markdown.set_relative_page_dir (relative_page_dir)
			Result := Markdown.as_html (lines.joined_lines)
		end

feature {NONE} -- Internal attributes

	relative_page_dir: EL_DIR_PATH
		-- class page directory relative to index page directory tree

feature {NONE} -- Constants

	Markdown: NOTE_MARKDOWN_RENDERER
		once
			create Result
		end
end
