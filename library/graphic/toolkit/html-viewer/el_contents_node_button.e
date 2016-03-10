note
	description: "[
		Button to expand hidden content links underneath level 3 link
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

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

	make (a_content_level_3_link: EL_HTML_TEXT_HYPERLINK_AREA; a_plus_pixmap, a_minus_pixmap: EL_SVG_PIXMAP)
		do
			content_level_3_link := a_content_level_3_link; plus_pixmap := a_plus_pixmap; minus_pixmap := a_minus_pixmap
			create node_expand_button
			node_expand_button.select_actions.extend (agent on_hide_show_sub_level_3_links)
			node_expand_button.set_pixmap (plus_pixmap)
			node_expand_button.set_minimum_size (plus_pixmap.width, plus_pixmap.height)
			make_box (0, 0)
			extend (create {EV_CELL})
			extend_unexpanded (node_expand_button)
			node_expand_button.disable_tabable_from
		end

feature -- Status query

	is_expanded: BOOLEAN

feature {NONE} -- Implementation

	on_hide_show_sub_level_3_links
		do
			if is_expanded then
				content_level_3_link.hide_sub_links
				node_expand_button.set_pixmap (plus_pixmap)
				is_expanded := False
			else
				content_level_3_link.show_sub_links
				node_expand_button.set_pixmap (minus_pixmap)
				is_expanded := True
			end
			-- parent.set_focus
			-- Needed for windows to prevent focus dots from spoiling graphic but doens't work
		end

	content_level_3_link: EL_HTML_TEXT_HYPERLINK_AREA

	plus_pixmap, minus_pixmap: EL_SVG_PIXMAP

	node_expand_button: EV_BUTTON

end
