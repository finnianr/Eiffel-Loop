note
	description: "Summary description for {DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 15:28:52 GMT (Thursday 6th June 2013)"
	revision: "2"

deferred class
	EL_VERTICAL_DIALOG

inherit
	EV_UNTITLED_DIALOG
		redefine
			show_modal_to_window
		end

	EL_WINDOW_POSITIONING
		undefine
			default_create, copy
		end

	EL_MODULE_GUI
		undefine
			default_create, copy
		end

	EL_MODULE_ICON
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

	EL_MODULE_STRING
		undefine
			default_create, copy
		end

	EL_MODULE_IMAGE
		undefine
			default_create, copy
		end

feature {NONE} -- Initialization

	make_dialog (a_title: EL_ASTRING; a_default_button_action: like default_button_action)
			-- build dialog with components
		do
			default_create
			set_title (a_title.to_unicode); default_button_action := a_default_button_action
			disable_user_resize
			set_icon_pixmap (Application_icon_pixmap)
			create dialog.make_with_container (Current, agent new_dialog_box)
			set_buttons
			show_actions.extend (agent on_show)
		end

feature -- Access

	title_label: EL_PIXMAPABLE_LABEL

	content_area_background_color: EL_COLOR
		do
			Result := Default_content_area_background_color
		end

	border_color: EL_COLOR
		do
			Result := Default_border_color
		end

feature -- Status query

	has_cancel_button: BOOLEAN
		do
			Result := dialog_buttons.has (cancel_button)
		end

	is_container_background_color_propagated: BOOLEAN

	is_cancelled: BOOLEAN

feature -- Element change

	set_title_font (a_title_font : like Default_title_font)
		do
			title_label.set_font (a_title_font)
		end

	set_cancel_button_text (a_text: EL_ASTRING)
		do
			cancel_button.set_text (a_text.to_unicode)
		end

	set_default_button_text (a_text: EL_ASTRING)
		do
			default_button.set_text (a_text.to_unicode)
		end

feature -- Basic operations

	show_modal_to_window (a_window: EV_WINDOW)
			-- This over ride is a workaround to a bug in Windows implementation where dialog frame bottom border is not drawn
			-- See bug report #18604
		do
			if {PLATFORM}.is_windows and then attached {EV_UNTITLED_DIALOG} a_window as a_untitled_dialog then
				show_actions.extend_kamikaze (agent draw_bottom_border)
			end
			Precursor (a_window)
		end

	draw_bottom_border
			-- A workaround for bug #18604
		do
			if attached {like new_dialog_box} item as box then
				box.extend_unexpanded (create {EV_CELL})
				box.last.set_minimum_height (box.border_width + 1)
				box.last.set_background_color (border_color)
			end
		end

	rebuild
		do
			dialog.update
			set_buttons
		end

feature {NONE} -- Events

	on_cancel
		do
			destroy
			is_cancelled := True
		end

	on_show
		do
		end

feature {NONE} -- Factory

	new_dialog_box: EL_VERTICAL_BOX
		do
			title_label := new_title_label
			create drag.make (Current, title_label, Grab_hand_pixmap)

			create default_button.make_with_text (default_button_text.to_unicode)

			create cancel_button.make_with_text (cancel_button_text.to_unicode)
			Result := GUI.vertical_box (Dialog_border_width_cms, 0, << title_label >>)
			Result.set_background_color (border_color)
			Result.extend (new_border_box)
		end

	new_border_box: EL_VERTICAL_BOX
		local
			inner_border_cms: REAL
			l_buttons: like dialog_buttons
			outer_box: EL_BOX; button_box: EL_HORIZONTAL_BOX
		do
			inner_border_cms := Border_inner_width_cms - 0.05
			l_buttons := dialog_buttons
			outer_box := new_outer_box
			add_components (outer_box)
			Result := GUI.vertical_box (inner_border_cms, inner_border_cms, << outer_box >>)
			if not l_buttons.is_empty then
				button_box := GUI.horizontal_box (0, 0.4, l_buttons)
				button_box.put_front (create {EL_EXPANDED_CELL})
				Result.extend_unexpanded (button_box)
			end
			if content_area_background_color /= Default_content_area_background_color then
				Result.set_background_color (content_area_background_color)
				Result.propagate_background_color
			end
		end

	new_title_label: like title_label
		do
			create Result.make_with_text_and_font (title, Default_title_font)
			if Title_background_pixmap.width * Title_background_pixmap.height > 1 then
				Result.set_pixmap (Title_background_pixmap)
			end
			Result.align_text_center
		end

	new_label (a_text: READABLE_STRING_GENERAL): EL_LABEL
		do
			create Result.make_with_text (a_text)
			Result.align_text_left
		end

	new_outer_box: EL_BOX
		do
			create {EL_VERTICAL_BOX} Result.make (0, Box_separation_cms)
		end

	new_inner_box (widgets: ARRAY [EV_WIDGET]): EL_BOX
		do
			Result := GUI.horizontal_box (0, Widget_separation_cms, widgets)
		end

feature {NONE} -- Implementation

	set_buttons
		do
			if dialog_buttons.has (default_button) then
				set_default_push_button (default_button)
				default_button.select_actions.extend (default_button_action)
			end
			if has_cancel_button then
				set_default_cancel_button (cancel_button)
				cancel_button.select_actions.extend (agent on_cancel)
			end
		end

	add_components (box: EL_BOX)
		local
			l_components: like components
			i: INTEGER
		do
			create l_components.make_from_array (components)
			create component_boxes.make (l_components.count)
			from i := 1 until  i > l_components.count loop
				component_boxes.extend (new_inner_box (l_components [i]))
				i := i + 1
			end
			box.append_unexpanded (component_boxes.to_array)
			if content_area_background_color /= Default_content_area_background_color
				and then is_container_background_color_propagated
			then
				box.propagate_background_color
			end
		end

	dialog_buttons: ARRAY [EV_WIDGET]
		do
			Result := << default_button, cancel_button >>
		end

feature {NONE} -- Unimplementated

	components: ARRAY [ARRAY [EV_WIDGET]]
		deferred
		end

	application_icon_pixmap: EV_PIXMAP
		deferred
		end

feature {NONE} -- Implementation: attributes

	default_button: EV_BUTTON

	cancel_button: EV_BUTTON

	component_boxes: ARRAYED_LIST [EL_BOX]

	inner_box_separation: REAL

	drag: EL_WINDOW_DRAG

	default_button_action: PROCEDURE [ANY, TUPLE]

	dialog: EL_MANAGED_WIDGET [like new_dialog_box]

feature -- Constants

	Default_button_text: EL_ASTRING
		once
			Result := "OK"
		end

	Cancel_button_text: EL_ASTRING
		once
			Result := "Cancel"
		end

	Default_title_font: EV_FONT
		once
			create Result
			Result.set_weight (GUI.Weight_bold)
		end

	Title_background_pixmap: EV_PIXMAP
		once
			create Result.make_with_size (1, 1)
		end

	Grab_hand_pixmap: EL_SVG_PIXMAP
		once
			Result := Icon.svg_of_width_cms (Grab_hand_svg_path_steps, 0.7, GUI.color_dialog)
		end

	Grab_hand_svg_path_steps: STRING
		once
			Result := "cursor/hand.svg"
		end

	Default_content_area_background_color: EL_COLOR
		once
			create Result
		end

	Default_border_color: EL_COLOR
		once
			Result := GUI.gray
		end

feature {NONE} -- Dimensions

	Border_inner_width_cms: REAL
		once
			Result := 0.35
		end

	Dialog_border_width_cms: REAL
		once
			Result := 0.11
		end

	Widget_separation_cms: REAL
		once
			Result := 0.3
		end

	Box_separation_cms: REAL
		once
			Result := 0.3
		end

end
