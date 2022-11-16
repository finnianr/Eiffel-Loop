note
	description: "Hyperlink menu"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "13"

deferred class
	EL_HYPERLINK_MENU [G -> EL_NAMEABLE [ZSTRING]]

inherit
	EL_MODELED_COLUMNS_DIALOG
		rename
			make as make_dialog
		redefine
			on_cancel, on_show
		end

	EL_MODULE_COLOR

feature {NONE} -- Initialization

	make (
		a_model: like model; a_item_list: like item_list; a_select_action: like select_action;
		a_font: like font; a_link_text_color: EV_COLOR
	)
		local
			link: EL_HYPERLINK_AREA
		do
			item_list := a_item_list
			select_action := a_select_action
			font := a_font
			create links.make (20)
			from item_list.start until item_list.after loop
				create link.make (item_list.item.name, agent on_select (item_list.item), font, Color.Dialog)
				link.set_link_text_color (a_link_text_color)
--				link.set_tooltip (a_tooltip: READABLE_STRING_GENERAL)
				links.extend (link)
				item_list.forth
			end
			make_info (a_model)
			window.focus_out_actions.extend (agent on_cancel)
		end

feature {NONE} -- Events

	on_show
		do
			window.set_focus
		end

	on_cancel
		do
			window.focus_out_actions.block
			Precursor
		end

feature {NONE} -- Implementation

	components: ARRAY [ARRAY [EV_WIDGET]]
			--
		do
			Result := << links.to_array >>
		end

	dialog_buttons: ARRAY [EV_WIDGET]
		do
			create Result.make_empty
		end

	on_select (list_item: G)
		do
			select_action.call ([list_item])
			on_cancel
		end

feature {NONE} -- Internal attributes

	font: EV_FONT

	item_list: LIST [G]

	select_action: PROCEDURE [G]

	links: ARRAYED_LIST [EV_WIDGET]

end