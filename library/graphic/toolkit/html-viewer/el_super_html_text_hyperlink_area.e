note
	description: "[
		HTML viewer navigation link for heading level >=3 containing expandable group of sub-level links.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-23 13:39:00 GMT (Tuesday 23rd August 2022)"
	revision: "4"

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
			change_sub_links (False)
		end

	show_sub_links
		do
			change_sub_links (True)
		end

	change_sub_links (visible: BOOLEAN)
		-- change sub-link visibility
		do
			across sub_links as link loop
				if visible then
					link.item.show
				else
					link.item.hide
				end
			end
		end

feature -- Access

	sub_links: EL_ARRAYED_LIST [EL_HTML_TEXT_HYPERLINK_AREA]

end