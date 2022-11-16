note
	description: "Note HTML text element list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	NOTE_HTML_TEXT_ELEMENT_LIST

inherit
	HTML_TEXT_ELEMENT_LIST
		rename
			make as make_list
		redefine
			Markdown, new_html_element, new_preformatted_html_element
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (markdown_lines: EL_ZSTRING_LIST; a_relative_page_dir: like relative_page_dir)
		do
			relative_page_dir := a_relative_page_dir
			make_list (markdown_lines)
		end

feature {NONE} -- Factory

	new_html_element: HTML_TEXT_ELEMENT
			-- escaped description with html formatting
		do
			Markdown.set_relative_page_dir (relative_page_dir)
			Result := Precursor
		end

	new_preformatted_html_element: HTML_TEXT_ELEMENT
		do
			Preformatted_markdown.set_relative_page_dir (relative_page_dir)
			create Result.make (Preformatted_markdown.as_html (lines.joined_lines), Type_preformatted)
		end

feature {NONE} -- Internal attributes

	relative_page_dir: DIR_PATH
		-- class page directory relative to index page directory tree

feature {NONE} -- Constants

	Markdown: NOTE_MARKDOWN_RENDERER
		once
			create Result
		end

	Preformatted_markdown: PREFORMATTED_NOTE_MARKDOWN_RENDERER
		once
			create Result
		end
end