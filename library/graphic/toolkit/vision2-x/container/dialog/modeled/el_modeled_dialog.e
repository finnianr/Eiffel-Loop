note
	description: "[
		Dialog created from a model of type [$source EL_DIALOG_MODEL] with support for
		title bars with customizeable background pixmaps.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 8:33:45 GMT (Saturday 11th June 2022)"
	revision: "2"

deferred class
	EL_MODELED_DIALOG

inherit
	EL_MODELED_DIALOG_IMPLEMENTATION

	EL_MODULE_ORIENTATION

	EL_MODULE_SCREEN

feature {NONE} -- Initialization

	make (a_model: like model; a_default_action: like default_action)
		local
			shortcuts: EL_KEYBOARD_SHORTCUTS
		do
			model := a_model; default_action := a_default_action

			create_implementation; create_interface_objects

			if a_model.minimum_width_cms > 0.0 then
				window.set_width (Screen.horizontal_pixels (a_model.minimum_width_cms))
			end

			-- both of these lines are necessary as workaround Windows bug of over-extended border on bottom
			-- https://www2.eiffel.com/support/report_detail/19319
			window.disable_user_resize; window.disable_border

			if style.has_application_icon_pixmap then
				window.set_icon_pixmap (style.application_icon_pixmap)
			end
			dialog_box := new_dialog_box
			window.put (dialog_box)
			set_dialog_buttons

			-- make sure escape key works even without any buttons
			if not a_model.has_buttons and a_model.escape_key_enabled then
				create shortcuts.make (window)
				shortcuts.add_unmodified_key_action (Key.Key_escape, agent on_cancel)
			end
			window.show_actions.extend (agent on_show)
			if {PLATFORM}.is_windows then
				-- Word around for obscured close button
				window.enable_user_resize
			end
		end

	make_info (a_model: like model)
		do
			make (a_model, agent do_nothing)
		end

feature -- Measurement

	height: INTEGER
		do
			Result := window.height
		end

	width: INTEGER
		do
			Result := window.width
		end

feature -- Status change

	position_center (a_window: EV_POSITIONED)
		-- position `Current' dialog in center of `a_window'
		do
			Screen.center_in (window, a_window, True)
		end

	set_default_to_close
		-- set `default_button' to close dialog giving focus to `default_button'
		do
			model.set_default_button_text (Word.close)
			replace_default_button
			default_action := agent destroy
			GUI.do_once_on_idle (agent default_button.set_focus)
		end

	set_maximum_size (a_maximum_width, a_maximum_height: INTEGER)
		do
			window.set_maximum_size (a_maximum_width, a_maximum_height)
		end

	set_focus
		do
			window.set_focus
		end

feature -- Status query

	is_cancelled: BOOLEAN

	is_destroyed: BOOLEAN
		do
			Result := window.is_destroyed
		end

	is_displayed: BOOLEAN
		do
			Result := window.is_displayed
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
			window.set_default_push_button (new_default)
		end

feature -- Element change

	set_title (a_title: separate READABLE_STRING_GENERAL)
		do
			window.set_title (a_title)
		end

feature -- Basic operations

	show
		do
			window.show
		end

	show_modal_centered (a_window: EV_WINDOW)
		do
			Screen.center_in (window, a_window, True)
			window.show_modal_to_window (a_window)
		end

	show_modal_to_window (a_window: EV_WINDOW)
		do
			window.show_modal_to_window (a_window)
		end

	show_relative_to_window (a_window: EV_WINDOW)
		do
			window.show_relative_to_window (a_window)
		end

feature -- Screen positioning

	center
		do
			Screen.center (window)
		end

	center_in (a_window: EV_POSITIONED; top_maximum: BOOLEAN)
		do
			Screen.center_in (window, a_window, top_maximum)
		end

	set_position (x, y: INTEGER)
		do
			Screen.set_position (window, x, y)
		end

	set_best_position (rectangle: EV_RECTANGLE; preferred_directions: ITERABLE [INTEGER]; border_cms: REAL)
		-- position `Current' in relation to point on `rectangle' indicated by `preferred_directions'
		-- with a clearance of `border_cms' centimeters
		require
			valid_directions: across preferred_directions as direction all Orientation.is_valid_position (direction.item) end
		local
			current_rect: EL_RECTANGLE; contained: BOOLEAN
		do
			create current_rect.make_for_widget (window)
			across preferred_directions as direction until contained loop
				current_rect.move_outside (rectangle, direction.item, 0.3)
				contained := Screen.useable_area.contains (current_rect)
			end
			if not contained then
				current_rect.move_center (rectangle)
			end
			set_position (current_rect.x, current_rect.y)
		end

	set_screen_position_left (y: INTEGER)
		-- set position at left of `useable_area'
		do
			Screen.set_position_left (window, y)
		end

	set_y_position (y: INTEGER)
		do
			Screen.set_y_position (window, y)
		end

feature {NONE} -- Factory

	new_dialog_box: EL_VERTICAL_BOX
		do
			create Result.make_unexpanded (layout.dialog_border_width_cms, 0, << >>)
			if attached {EL_CUSTOM_TITLED_DIALOG} window as custom
				and then attached custom.title_label as title_label
			then
				Result.extend_unexpanded (title_label)
			end
			Result.extend (new_border_box)
			Result.set_background_color (style.border_color)
		end

feature {NONE} -- Event handling

	on_cancel
		do
			window.destroy
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
				window.disable_user_resize
			end
		end

feature {NONE} -- Implementation

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

	destroy
		do
			window.destroy
		end

	set_dialog_buttons
		do
			if model.has_default_button_text then
				window.set_default_push_button (default_button)
			end
			if model.has_cancel_button_text then
				window.set_default_cancel_button (cancel_button)
			end
		end

feature {NONE} -- Implementation: attributes

	default_action: PROCEDURE

	dialog_box: like new_dialog_box

end