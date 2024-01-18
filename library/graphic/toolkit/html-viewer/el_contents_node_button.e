note
	description: "Button to expand sub-links in level 3 link ${EL_SUPER_HTML_TEXT_HYPERLINK_AREA}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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

	make (a_content_super_link: EL_SUPER_HTML_TEXT_HYPERLINK_AREA; a_pixmap_set: like pixmap_set)
		do
			content_super_link := a_content_super_link; pixmap_set := a_pixmap_set
			create node_expand_button
			node_expand_button.select_actions.extend (agent on_toggle_sublinks)
			node_expand_button.set_pixmap (pixmap_set [False])
			if attached pixmap_set.first as p then
				node_expand_button.set_minimum_size (p.width, p.height)
			end
			make_box (0, 0)
			extend (create {EV_CELL})
			extend_unexpanded (node_expand_button)
			node_expand_button.disable_tabable_from
		end

feature -- Status query

	sub_links_visible: BOOLEAN

feature {NONE} -- Event handling

	on_toggle_sublinks
		-- toggle sub-links visibility
		do
			sub_links_visible := not sub_links_visible
			content_super_link.change_sub_links (sub_links_visible)
			node_expand_button.set_pixmap (pixmap_set [sub_links_visible])
			-- parent.set_focus
			-- Needed for windows to prevent focus dots from spoiling graphic but doens't work
		end

feature {NONE} -- Internal attributes

	content_super_link: EL_SUPER_HTML_TEXT_HYPERLINK_AREA

	node_expand_button: EV_BUTTON

	pixmap_set: EL_BOOLEAN_INDEXABLE [EL_SVG_PIXMAP]
		-- node expand/contract pixmap

end