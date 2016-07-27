note
	description: "Summary description for {EL_HYPERLINK_MENU}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:22:50 GMT (Saturday 26th December 2015)"
	revision: "6"

deferred class
	EL_HYPERLINK_MENU [G -> EL_NAMEABLE]

inherit
	EL_HORIZONTAL_DIALOG
		redefine
			on_cancel, on_show, dialog_buttons, Widget_separation_cms, content_area_color
		end

	EL_MODULE_KEY
		undefine
			copy , default_create
		end

feature {NONE} -- Initialization

	make (
		a_heading: ZSTRING; a_item_list: like item_list; a_select_action: like select_action;
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
				create link.make (item_list.item.name, agent on_select (item_list.index), font, GUI.color_dialog)
				link.set_link_text_color (a_link_text_color)
				links.extend (link)
				item_list.forth
			end
			make_dialog (a_heading, agent do_nothing)
			focus_out_actions.extend (agent on_cancel)
			create keyboard_shortcuts.make (Current)
			keyboard_shortcuts.add_unmodified_key_action (Key.Key_escape, agent on_cancel)
		end

feature -- Access

	content_area_color: EL_COLOR
		do
			Result := GUI.text_field_background_color
		end

feature {NONE} -- Events

	on_show
		do
			set_focus
		end

	on_cancel
		do
			focus_out_actions.block
			Precursor
		end

feature {NONE} -- Implementation

	keyboard_shortcuts: EL_KEYBOARD_SHORTCUTS

	components: ARRAY [ARRAY [EV_WIDGET]]
			--
		do
			Result := << links.to_array >>
		end

	dialog_buttons: ARRAY [EV_WIDGET]
		do
			create Result.make_empty
		end

	on_select (a_index: INTEGER)
		do
			item_list.go_i_th (a_index)
			select_action.call ([item_list.item])
			on_cancel
		end

	item_list: LIST [G]

	select_action: PROCEDURE [ANY, TUPLE [G]]

	font: EV_FONT

	links: ARRAYED_LIST [EV_WIDGET]

feature {NONE} -- Dimensions

	Widget_separation_cms: REAL
		once
			Result := 0.1
		end

end