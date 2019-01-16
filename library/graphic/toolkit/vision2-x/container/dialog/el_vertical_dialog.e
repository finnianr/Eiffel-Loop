note
	description: "Vertical dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-14 12:44:15 GMT (Monday 14th January 2019)"
	revision: "6"

deferred class
	EL_VERTICAL_DIALOG

inherit
	EV_UNTITLED_DIALOG
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position,
			title as internal_title
		redefine
			set_title, show_modal_to_window
		end

	EL_WINDOW
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

	EL_MODULE_DEFERRED_LOCALE
		undefine
			default_create, copy
		end

	EL_MODULE_SCREEN
		undefine
			default_create, copy
		end

	EL_MODULE_IMAGE
		undefine
			default_create, copy
		end

	EL_MODULE_VISION_2
		undefine
			default_create, copy
		end

	SD_COLOR_HELPER
		export
			{NONE} all
		undefine
			default_create, copy
		end

feature {NONE} -- Initialization

	make_dialog_with_button_texts (
		a_title: like title; a_button_text, a_cancel_button_text: ZSTRING
		a_default_button_action: like default_button_action
	)
		do
			button_text := a_button_text; cancel_button_text := a_cancel_button_text
			default_button_action := a_default_button_action
			default_create

			-- both of these lines are necessary as workaround Windows bug of over-extended border on bottom
			-- https://www2.eiffel.com/support/report_detail/19319
			disable_user_resize; disable_border

			set_title (a_title)
			set_icon_pixmap (Application_icon_pixmap)
			create dialog.make_with_container (Current, agent new_dialog_box)
			set_buttons

			show_actions.extend (agent on_show)
		end

	make_dialog (a_title: ZSTRING; a_default_button_action: like default_button_action)
			-- build dialog with components
		do
			make_dialog_with_button_texts (
				a_title, Locale * Eng_default_button_text, Locale * Eng_cancel_button_text,
				a_default_button_action
			)
		end

feature -- Access

	title: ZSTRING

	title_label: EL_LABEL_PIXMAP

	content_area_color: EL_COLOR
		do
			Result := Default_background_color
		end

	button_box_color: EL_COLOR
		do
			Result := Default_background_color
		end

	border_color: EL_COLOR
		do
			if content_area_color = Default_background_color then
				Result := Default_border_color
			else
				Result := color_with_lightness (content_area_color, -0.2).twin
			end
		end

	button_text: ZSTRING
		-- default button text

	cancel_button_text: ZSTRING

feature -- Status query

	has_cancel_button: BOOLEAN
		do
			Result := dialog_buttons.has (cancel_button)
		end

	is_cancelled: BOOLEAN

	is_widget_content_area_color (widget: EV_WIDGET): BOOLEAN
		do
			Result := not attached {EV_TEXT_COMPONENT} widget
		end

	is_container_propagated_with_content_area_color (container: EV_CONTAINER): BOOLEAN
		do
			Result := not attached {EV_NOTEBOOK} container
		end

feature -- Element change

	set_title (a_title: ZSTRING)
		do
			title := a_title
			Precursor (a_title.to_unicode)
		end

	set_title_font (a_title_font : like Default_title_font)
		do
			title_label.set_font_and_height (a_title_font)
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
			create drag.make (Current, title_label)

			default_button := new_button (button_text)
			cancel_button := new_button (cancel_button_text)

			create Result.make_unexpanded (Dialog_border_width_cms, 0, << title_label >>)
			Result.extend (new_border_box)
			Result.set_background_color (border_color)
		end

	new_border_box: EL_VERTICAL_BOX
		local
			button_box: like new_button_box; inner_border_cms: REAL
		do
			inner_border_cms := Border_inner_width_cms - 0.05
			create Result.make_unexpanded (inner_border_cms, inner_border_cms, << new_outer_box >>)
			button_box := new_button_box
			if not button_box.is_empty then
				right_align_buttons (button_box)
				Result.extend_unexpanded (button_box)
				if button_box_color /= Default_background_color then
					button_box.set_background_color (button_box_color)
				end
			end
			if content_area_color /= Default_background_color then
				propagate_content_area_color (Result)
			end
			Result.set_background_color (content_area_color)
		end

	new_button_box: EL_HORIZONTAL_BOX
		do
			create Result.make_unexpanded (0, 0.4, dialog_buttons)
		end

	new_title_label: like title_label
		do
			create Result.make_with_text_and_font (title, Default_title_font)
			Result.set_minimum_width (
				Default_title_font.string_width (internal_title) + Screen.horizontal_pixels (Border_inner_width_cms)
			)
			if Title_background_pixmap.width * Title_background_pixmap.height > 1 then
				Result.set_tile_pixmap (Title_background_pixmap)
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
			create {EL_VERTICAL_BOX} Result.make_unexpanded (0, Box_separation_cms, new_box_section_list.to_array)
		end

	new_section_box (widgets: ARRAY [EV_WIDGET]; section_index: INTEGER): EL_BOX
		do
			Result := Vision_2.new_horizontal_box (0, Widget_separation_cms, widgets)
		end

	new_button (a_text: ZSTRING): EV_BUTTON
		do
			create Result.make_with_text (a_text.to_string_32)
		end

feature {NONE} -- Implementation

	new_box_section_list: ARRAYED_LIST [EL_BOX]
		local
			list: LINEAR [ARRAY [EV_WIDGET]]; finite: like components
		do
			finite := components; list := finite.linear_representation
			create Result.make (finite.count)
			from list.start until list.after loop
				Result.extend (new_section_box (list.item, list.index))
				list.forth
			end
		end

	dialog_buttons: ARRAY [EV_WIDGET]
		do
			Result := << default_button, cancel_button >>
		end

	propagate_content_area_color (container: EV_CONTAINER)
		require
			content_area_color_set: content_area_color /= Default_background_color
		local
			list: LINEAR [EV_WIDGET]
		do
			if is_container_propagated_with_content_area_color (container) then
				if is_widget_content_area_color (container) then
					container.set_background_color (content_area_color)
				end
				list := container.linear_representation
				from list.start until list.after loop
					if attached {EV_CONTAINER} list.item as l_container then
						propagate_content_area_color (l_container)

					elseif is_widget_content_area_color (list.item) then
						list.item.set_background_color (content_area_color)
					end
					list.forth
				end
			end
		end

	right_align_buttons (button_box: EL_HORIZONTAL_BOX)
		do
			button_box.put_front (create {EL_EXPANDED_CELL})
		end

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

feature {NONE} -- Unimplementated

	components: FINITE [ARRAY [EV_WIDGET]]
		deferred
		end

	application_icon_pixmap: EV_PIXMAP
		deferred
		end

feature {NONE} -- Implementation: attributes

	default_button: like new_button

	cancel_button: like new_button

	component_boxes: ARRAYED_LIST [EL_BOX]

	inner_box_separation: REAL

	drag: EL_WINDOW_DRAG

	default_button_action: PROCEDURE

	dialog: EL_MANAGED_WIDGET [like new_dialog_box]

feature -- Constants

	Eng_default_button_text: ZSTRING
		once
			Result := "OK"
		end

	Eng_cancel_button_text: ZSTRING
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

	frozen Default_background_color: EL_COLOR
			-- Should not be redefined as it represents default dialog color
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
