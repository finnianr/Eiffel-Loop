note
	description: "[
		Level 3 page navigation contents link containing hideable sub-level links
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_HTML_TEXT_HYPERLINK_AREA

inherit
	EL_HYPERLINK_AREA
		redefine
			make_with_styles
		end

create
	make, make_with_styles

feature {NONE} -- Initialization

	make_with_styles (
		a_styled_text: like styled_text; a_font, a_fixed_font: EV_FONT
		a_action: PROCEDURE [ANY, TUPLE]; a_background_color: EV_COLOR
	)
			--
		do
			Precursor (a_styled_text, a_font, a_fixed_font, a_action, a_background_color)
			create sub_links.make
		end

feature -- Basic operations

	hide_sub_links
		do
			sub_links.do_all (agent {EL_HYPERLINK_AREA}.hide)
		end

	show_sub_links
		do
			sub_links.do_all (agent {EL_HYPERLINK_AREA}.show)
		end

feature -- Access

	sub_links: LINKED_LIST [EL_HYPERLINK_AREA]

end
