note
	description: "[
		Model-view dialog which displays the information in `model: [$source EL_DIALOG_MODEL]'
		according to the style and layout set in `model.style' and `model.layout'.
	]"
	notes: "[
		**Title Bar**
		
		If `model.style.title_background_pixmap' is set, a faux title bar with background pixmap is
		use instead of the default title bar. If no title is set then there is no title bar.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 14:16:03 GMT (Friday 14th August 2020)"
	revision: "10"

deferred class
	EL_VIEW_DIALOG

inherit
	EV_POSITIONABLE
		rename
			set_position as set_absolute_position,
			set_x_position as set_absolute_x_position,
			set_y_position as set_absolute_y_position
		end

	EL_POSITIONABLE

	EV_ANY_HANDLER undefine copy, default_create end

	EL_DIALOG_CONSTANTS
		export
			{NONE} all
		undefine
			copy, default_create
		end

	EL_MODULE_GUI

	EL_MODULE_ITERABLE

	EL_MODULE_KEY

	EL_MODULE_SCREEN

	EL_MODULE_VISION_2

feature {NONE} -- Initialization

	make (a_model: like model; a_default_action: like default_action)
		local
			shortcuts: EL_KEYBOARD_SHORTCUTS
		do
			model := a_model; default_action := a_default_action

			create_implementation; create_interface_objects

			if a_model.minimum_width_cms > 0.0 then
				internal_dialog.set_width (Screen.horizontal_pixels (a_model.minimum_width_cms))
			end

			-- both of these lines are necessary as workaround Windows bug of over-extended border on bottom
			-- https://www2.eiffel.com/support/report_detail/19319
			internal_dialog.disable_user_resize; internal_dialog.disable_border

			if a_model.has_title then
				internal_dialog.set_title (a_model.title)
			end
			if model.style.has_application_icon_pixmap then
				internal_dialog.set_icon_pixmap (model.style.application_icon_pixmap)
			end
			create dialog.make_with_container (internal_dialog, agent new_dialog_box)
			set_buttons

			-- make sure escape key works even without any buttons
			if not a_model.has_buttons and a_model.escape_key_enabled then
				create shortcuts.make (internal_dialog)
				shortcuts.add_unmodified_key_action (Key.Key_escape, agent on_cancel)
			end
			internal_dialog.show_actions.extend (agent on_show)
		end

	make_info (a_property: like model)
		do
			make (a_property, agent do_nothing)
		end

feature -- Access

	background_color: EV_COLOR
		do
			Result := internal_dialog.background_color
		end

	model: EL_DIALOG_MODEL

feature -- Status query

	is_cancelled: BOOLEAN

	is_container_propagated_with_content_area_color (container: EV_CONTAINER): BOOLEAN
		do
			Result := not attached {EV_NOTEBOOK} container
		end

	is_displayed: BOOLEAN
		do
			Result := internal_dialog.is_displayed
		end

	is_widget_content_area_color (widget: EV_WIDGET): BOOLEAN
		do
			Result := not attached {EV_TEXT_COMPONENT} widget
		end

feature -- Status change

	set_maximum_size (a_maximum_width, a_maximum_height: INTEGER)
		do
			internal_dialog.set_maximum_size (a_maximum_width, a_maximum_height)
		end

	set_title (a_title: READABLE_STRING_GENERAL)
		do
			internal_set_title (a_title)
		end

feature -- Element change

	set_default_button (a_button: like new_button)
		-- replace the default button
		do
			button_box.start; button_box.search (default_button)
			if not button_box.exhausted then
				button_box.replace (a_button)
				button_box.disable_item_expand (a_button)
				default_button := a_button
				default_button.select_actions.extend (agent on_default)
				internal_dialog.set_default_push_button (a_button)
			end
		end

feature -- Basic operations

	position_center (a_window: EL_POSITIONABLE)
		do
			a_window.position_window_center (internal_dialog)
		end

	rebuild
		do
			dialog.update
			set_buttons
		end

	show
		do
			internal_dialog.show
		end

	show_modal_centered (main: EL_TITLED_WINDOW)
		do
			main.position_window_center (internal_dialog)
			show_modal_to_window (main)
		end

	show_modal_to_window (a_window: EV_WINDOW)
		do
			adjust_bottom_border (a_window)
			internal_dialog.show_modal_to_window (a_window)
		end

	show_relative_to_window (a_window: EV_WINDOW)
		do
			internal_dialog.show_relative_to_window (a_window)
		end

feature {NONE} -- Event handling

	on_cancel
		do
			destroy
			is_cancelled := True
		end

	on_default
		do
			if attached default_action as action then
				action.apply
			end
		end

	on_show
		do
		end

feature {NONE} -- Factory

	new_border_box: EL_VERTICAL_BOX
		local
			inner_border_cms: REAL
		do
			inner_border_cms := model.layout.border_inner_width_cms - 0.05
			create Result.make_unexpanded (inner_border_cms, inner_border_cms, << new_outer_box >>)
			if model.has_buttons then
				Result.extend_unexpanded (button_box)
			else
				create default_button
				create cancel_button
			end
			if model.style.has_content_area_color then
				propagate_content_area_color (Result)
			end
			Result.set_background_color (model.style.content_area_color)
		end

	new_box_section_list: ARRAYED_LIST [EL_BOX]
		local
			list: like components; i: INTEGER
		do
			list := components
			create Result.make (Iterable.count (list))
			across list as row loop
				i := i + 1
				Result.extend (new_section_box (row.item, i))
			end
		end

	new_button (a_text: READABLE_STRING_GENERAL): EL_BUTTON
		do
			if model.style.has_new_button_pixmap_set then
				create {EL_DECORATED_BUTTON} Result.make (new_text_pixmap (a_text))
			else
				create Result.make_with_text (a_text)
			end
		end

	new_button_list: ARRAYED_LIST [like new_button]
		do
			create Result.make (2)
			if model.has_default_button_text then
				default_button := new_button (model.default_button_text)
				Result.extend (default_button)
			else
				create default_button
			end
			if model.has_cancel_button_text then
				cancel_button := new_button (model.cancel_button_text)
				Result.extend (cancel_button)
			else
				create cancel_button
			end
		end

	new_button_row: ARRAYED_LIST [EV_WIDGET]
		do
			create Result.make (4)
			if model.layout.buttons_right_aligned then
				Result.extend (create {EL_EXPANDED_CELL})
			end
			across new_button_list as button loop
				Result.extend (button.item)
			end
			if model.layout.buttons_left_aligned then
				Result.extend (create {EL_EXPANDED_CELL})
			end
		end

	new_dialog_box: EL_VERTICAL_BOX
		local
			title_label: like new_title_label
		do
			create Result.make_unexpanded (model.layout.dialog_border_width_cms, 0, << >>)
			if model.style.has_title_background_pixmap and model.has_title then
				title_label := new_title_label
				internal_set_title := agent title_label.set_text
				create title_bar_drag.make (internal_dialog, title_label)
				Result.extend_unexpanded (title_label)
			end
			Result.extend (new_border_box)
			Result.set_background_color (model.style.border_color)
		end

	new_label (a_text: READABLE_STRING_GENERAL): EL_LABEL
		do
			create Result.make_with_text (a_text)
			Result.set_background_color (model.style.content_area_color)
			Result.set_font (model.style.label_font)
			Result.align_text_left
		end

	new_outer_box: EL_BOX
		do
			create {EL_VERTICAL_BOX} Result.make_unexpanded (
				0, model.layout.box_separation_cms, new_box_section_list.to_array
			)
		end

	new_section_box (widgets: ARRAY [EV_WIDGET]; section_index: INTEGER): EL_BOX
		local
			l_expanded: like expanded_widgets
		do
			l_expanded := expanded_widgets
			Result := Vision_2.new_horizontal_box (0, model.layout.row_separation_cms, widgets)
			across widgets as list loop
				if l_expanded.has (list.item) then
					Result.enable_item_expand (list.item)
				end
			end
		end

	new_text_pixmap (a_text: READABLE_STRING_GENERAL): EL_SVG_TEXT_BUTTON_PIXMAP_SET
		do
			Result := model.style.new_button_pixmap_set (a_text, model.style.content_area_color)
		end

	new_title_label: EL_LABEL_PIXMAP
		do
			create Result.make_with_text_and_font (internal_dialog.title, model.style.title_font)
			Result.set_width_for_border (model.layout.border_inner_width_cms)
			if model.style.has_title_background_pixmap then
				Result.set_tile_pixmap (model.style.title_background_pixmap)
			end
			Result.align_text_center
		end

	new_wrapped_label (a_text: READABLE_STRING_GENERAL; a_width: INTEGER): EL_WRAPPED_LABEL
		do
			create Result.make_to_width (a_text, model.style.label_font, a_width)
		end

feature {NONE} -- Implementation

	adjust_bottom_border (a_window: EV_WINDOW)
			-- This is a workaround to a bug in Windows implementation where dialog frame bottom border is not drawn
			-- See bug report #18604
		do
			if {PLATFORM}.is_windows and then attached {EV_UNTITLED_DIALOG} a_window as a_untitled_dialog then
				internal_dialog.show_actions.extend_kamikaze (agent draw_bottom_border)
			end
		end

	create_implementation
		do
			if model.style.has_title_background_pixmap or model.title.is_empty then
				create {EL_UNTITLED_DIALOG} internal_dialog
			else
				create internal_dialog
			end
			internal_set_title := agent internal_dialog.set_title
			implementation := internal_dialog.implementation
		end

	create_interface_objects
		do
			create button_box.make_unexpanded (0, model.layout.button_separation_cms, new_button_row.to_array)
			if model.style.has_button_box_color then
				button_box.set_background_color (model.style.button_box_color)
			end
		end

	dialog_implementation: EV_POSITIONABLE_I
		do
			Result := internal_dialog.implementation
		end

	draw_bottom_border
			-- A workaround for bug #18604
		do
			if attached {like new_dialog_box} internal_dialog.item as box then
				box.extend_unexpanded (create {EV_CELL})
				box.last.set_minimum_height (box.border_width + 1)
				box.last.set_background_color (model.style.border_color)
			end
		end

	expanded_widgets: ARRAY [EV_WIDGET]
		do
			Result := Default_expanded_widgets
		end

	process_events
		do
			internal_dialog.ev_application.process_events
		end

	propagate_content_area_color (container: EV_CONTAINER)
		require
			content_area_color_set: model.style.has_content_area_color
		local
			list: LINEAR [EV_WIDGET]
		do
			if is_container_propagated_with_content_area_color (container) then
				if is_widget_content_area_color (container) then
					container.set_background_color (model.style.content_area_color)
				end
				list := container.linear_representation
				from list.start until list.after loop
					if attached {EV_CONTAINER} list.item as l_container then
						propagate_content_area_color (l_container)

					elseif is_widget_content_area_color (list.item) then
						list.item.set_background_color (model.style.content_area_color)
					end
					list.forth
				end
			end
		end

	set_buttons
		do
			if model.has_default_button_text then
				internal_dialog.set_default_push_button (default_button)
				default_button.select_actions.extend (agent on_default)
			end
			if model.has_cancel_button_text then
				internal_dialog.set_default_cancel_button (cancel_button)
				cancel_button.select_actions.extend (agent on_cancel)
			end
		end

feature {NONE} -- Unimplementated

	components: ITERABLE [ARRAY [EV_WIDGET]]
		deferred
		end

feature {EV_ANY_HANDLER} -- Implementation: attributes

	internal_dialog: EL_DIALOG

	internal_set_title: PROCEDURE [READABLE_STRING_GENERAL]

feature {NONE} -- Implementation: attributes

	button_box: EL_HORIZONTAL_BOX

	cancel_button: like new_button

	default_action: PROCEDURE

	default_button: like new_button

	dialog: EL_MANAGED_WIDGET [like new_dialog_box]

	title_bar_drag: detachable EL_WINDOW_DRAG

feature {NONE} -- Constants

	Default_expanded_widgets: ARRAY [EV_WIDGET]
		once
			create Result.make_empty
		end

end
