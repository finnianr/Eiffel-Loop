note
	description: "Summary description for {EIFFEL_NOTE_HTML_TEXT_ELEMENT_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-22 16:38:54 GMT (Friday 22nd July 2016)"
	revision: "1"

class
	EIFFEL_NOTE_HTML_TEXT_ELEMENT_LIST

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

	make (markdown_lines: EL_ZSTRING_LIST; a_relative_class_dir: like relative_class_dir)
		do
			relative_class_dir := a_relative_class_dir
			make_list (markdown_lines)
		end

feature {NONE} -- Implementation

	html_description: ZSTRING
			-- escaped description with html formatting
		do
			Markdown.set_relative_class_dir (relative_class_dir)
			Result := Markdown.as_html (lines.joined_lines)
		end

feature {NONE} -- Internal attributes

	relative_class_dir: EL_DIR_PATH
		-- class page directory relative to index page directory tree

feature {NONE} -- Constants

	Markdown: EIFFEL_NOTE_MARKDOWN_RENDERER
		once
			create Result
		end
end
