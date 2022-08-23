note
	description: "[
		Button to expand hidden content links underneath level 3 link
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-08-23 11:10:01 GMT (Tuesday 23rd August 2022)"
	revision: "5"

class
	EL_CONTENTS_NODE_BUTTON

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		end

create
	make

feature {NONE} -- Initialization

	make (a_content_super_link: EL_SUPER_HTML_TEXT_HYPERLINK_AREA; a_expanded_pixmap: like expanded_pixmap)
		do
			content_super_link := a_content_super_link; expanded_pixmap := a_expanded_pixmap
			create node_expand_button
			node_expand_button.select_actions.extend (agent on_hide_show_sub_super_links)
			node_expand_button.set_pixmap (expanded_pixmap [False])
			node_expand_button.set_minimum_size (expanded_pixmap.last.width, expanded_pixmap.last.height)
			make_box (0, 0)
			extend (create {EV_CELL})
			extend_unexpanded (node_expand_button)
			node_expand_button.disable_tabable_from
		end

feature -- Status query

	is_expanded: BOOLEAN

feature {NONE} -- Implementation

	on_hide_show_sub_super_links
		do
			if is_expanded then
				content_super_link.hide_sub_links
				is_expanded := False
			else
				content_super_link.show_sub_links
				is_expanded := True
			end
			node_expand_button.set_pixmap (expanded_pixmap [is_expanded])
			-- parent.set_focus
			-- Needed for windows to prevent focus dots from spoiling graphic but doens't work
		end

	content_super_link: EL_SUPER_HTML_TEXT_HYPERLINK_AREA

	expanded_pixmap: EL_BOOLEAN_INDEXABLE [EL_SVG_PIXMAP]

	node_expand_button: EV_BUTTON

end