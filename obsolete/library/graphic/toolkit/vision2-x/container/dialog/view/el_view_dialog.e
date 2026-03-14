note
	description: "[
		Model-view dialog which displays the information in `model: [$source EL_DIALOG_MODEL]'
		according to the style and layout set in `style' and `layout'.
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
	date: "2022-04-20 6:56:25 GMT (Wednesday 20th April 2022)"
	revision: "20"

deferred class
	EL_VIEW_DIALOG

inherit
	EV_POSITIONABLE
		redefine
			destroy
		end

	EL_MODELED_DIALOG_COMPONENTS
		rename
			implementation as internal_dialog
		undefine
			copy, default_create
		end

	EL_MODULE_ORIENTATION

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
			if style.has_application_icon_pixmap then
				internal_dialog.set_icon_pixmap (style.application_icon_pixmap)
			end
			dialog_box := new_dialog_box
			internal_dialog.put (dialog_box)
			set_dialog_buttons

			-- make sure escape key works even without any buttons
			if not a_model.has_buttons and a_model.escape_key_enabled then
				create shortcuts.make (internal_dialog)
				shortcuts.add_unmodified_key_action (Key.Key_escape, agent on_cancel)
			end
			internal_dialog.show_actions.extend (agent on_show)
			if {PLATFORM}.is_windows then
				-- Word around for obscured close button
				internal_dialog.enable_user_resize
			end
		end

	make_info (a_model: like model)
		do
			make (a_model, agent do_nothing)
		end

feature -- Access

	background_color: EV_COLOR
		do
			Result := internal_dialog.background_color
		end

feature -- Status query

	is_cancelled: BOOLEAN

	is_displayed: BOOLEAN
		do
			Result := internal_dialog.is_displayed
		end

feature -- Status change

	position_center (a_window: EV_POSITIONED)
		-- position `Current' dialog in center of `a_window'
		do
			Screen.center_in (internal_dialog, a_window, True)
		end

	set_maximum_size (a_maximum_width, a_maximum_height: INTEGER)
		do
			internal_dialog.set_maximum_size (a_maximum_width, a_maximum_height)
		end

	set_title (a_title: READABLE_STRING_GENERAL)
		do
			internal_set_title (a_title)
		end

	set_default_to_close
		-- set `default_button' to close dialog giving focus to `default_button'
		do
			model.set_default_button_text (Word.close)
			replace_default_button
			default_action := agent destroy
			GUI.do_once_on_idle (agent default_button.set_focus)
		end

feature -- Element change

	replace_default_button
		-- replace the `default_button' with a new one
		local
			new_default: like new_default_button
		do
			new_default := new_default_button
			Widget.replace (default_button, new_default)
			default_button := new_default
			internal_dialog.set_default_push_button (new_default)
		end

feature -- Basic operations

	destroy
		do
			-- Cannot call `implementation.destroy' on Windows
			internal_dialog.destroy
		end

	rebuild
		local
			new_box: like new_dialog_box
		do
			create_interface_objects
			new_box := new_dialog_box
			Widget.replace (dialog_box, new_box)
			dialog_box := new_box
			set_dialog_buttons
		end

	set_best_position (rectangle: EV_RECTANGLE; preferred_directions: ITERABLE [INTEGER]; border_cms: REAL)
		-- position `Current' in relation to point on `rectangle' indicated by `preferred_directions'
		-- with a clearance of `border_cms' centimeters
		require
			valid_directions: across preferred_directions as direction all Orientation.is_valid_position (direction.item) end
		local
			current_rect: EL_RECTANGLE; contained: BOOLEAN
		do
			create current_rect.make_for_widget (Current)
			across preferred_directions as direction until contained loop
				current_rect.move_outside (rectangle, direction.item, 0.3)
				contained := Screen.useable_area.contains (current_rect)
			end
			if not contained then
				current_rect.move_center (rectangle)
			end
			Screen.set_position (Current, current_rect.x, current_rect.y)
		end

	show
		do
			internal_dialog.show
		end

	show_modal_centered (a_window: EV_WINDOW)
		do
			Screen.center_in (internal_dialog, a_window, True)
			show_modal_to_window (a_window)
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
			-- make sure to call `Precursor' in redefinition
			if {PLATFORM}.is_windows then
				-- Word around for obscured close button
				internal_dialog.disable_user_resize
			end
		end

feature {NONE} -- Factory

	new_dialog_box: EL_VERTICAL_BOX
		local
			title_label: like new_title_label
		do
			create Result.make_unexpanded (layout.dialog_border_width_cms, 0, << >>)
			if style.has_title_background_pixmap and model.has_title then
				title_label := new_title_label
				internal_set_title := agent title_label.set_text
				create title_bar_drag.make (internal_dialog, title_label)
				Result.extend_unexpanded (title_label)
			end
			Result.extend (new_border_box)
			Result.set_background_color (style.border_color)
		end

	new_title_label: EL_LABEL_PIXMAP
		do
			create Result.make_with_text_and_font (model.title, style.title_font)
			Result.set_width_for_border (layout.border_inner_width_cms)
			if style.has_title_background_pixmap then
				Result.set_tile_pixmap (style.title_background_pixmap)
			end
			Result.align_text_center
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
			if style.has_title_background_pixmap or model.title.is_empty then
				create {EV_UNTITLED_DIALOG} internal_dialog
			else
				create internal_dialog
			end
			internal_set_title := agent internal_dialog.set_title
			implementation := internal_dialog.implementation
		end

	create_interface_objects
		do
			if model.has_default_button_text then
				default_button := new_default_button
			else
				create default_button
			end
			if model.has_cancel_button_text then
				cancel_button := new_button (model.cancel_button_text)
				cancel_button.select_actions.extend (agent on_cancel)
			else
				create cancel_button
			end
		end

	set_dialog_buttons
		do
			if model.has_default_button_text then
				internal_dialog.set_default_push_button (default_button)
			end
			if model.has_cancel_button_text then
				internal_dialog.set_default_cancel_button (cancel_button)
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
				box.last.set_background_color (style.border_color)
			end
		end

	process_events
		do
			internal_dialog.ev_application.process_events
		end

feature {EV_ANY_HANDLER} -- Implementation: attributes

	internal_set_title: PROCEDURE [READABLE_STRING_GENERAL]

	internal_dialog: EV_DIALOG

feature {NONE} -- Implementation: attributes

	default_action: PROCEDURE

	dialog_box: like new_dialog_box

	title_bar_drag: detachable EL_WINDOW_DRAG

end
