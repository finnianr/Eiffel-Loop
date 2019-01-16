note
	description: "[
		HTML viewer navigation link for heading level >=3 containing expandable group of sub-level links.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-11 18:51:49 GMT (Friday 11th January 2019)"
	revision: "3"

class
	EL_SUPER_HTML_TEXT_HYPERLINK_AREA

inherit
	EL_HTML_TEXT_HYPERLINK_AREA
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (html_text: EL_HTML_TEXT; header: EL_FORMATTED_TEXT_HEADER)
		do
			create sub_links.make_empty
			Precursor (html_text, header)
		end

feature -- Basic operations

	hide_sub_links
		do
			sub_links.do_all (agent {EL_HTML_TEXT_HYPERLINK_AREA}.hide)
		end

	show_sub_links
		do
			sub_links.do_all (agent {EL_HTML_TEXT_HYPERLINK_AREA}.show)
		end

feature -- Access

	sub_links: EL_ARRAYED_LIST [EL_HTML_TEXT_HYPERLINK_AREA]

end
