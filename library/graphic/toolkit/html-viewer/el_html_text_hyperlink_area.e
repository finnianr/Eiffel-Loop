note
	description: "HTML viewer navigation link"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_HTML_TEXT_HYPERLINK_AREA

inherit
	EL_HYPERLINK_AREA
		rename
			make as make_link
		end

create
	make

feature {NONE} -- Initialization

	make (html_text: EL_HTML_TEXT; header: EL_FORMATTED_TEXT_HEADER)
		do
			level := header.level
			make_link (
				header.text, agent html_text.scroll_to_heading_line (header.interval.lower),
				html_text.content_heading_font (header), Color.text_field_background
			)
		end

feature -- Access

	level: INTEGER
end