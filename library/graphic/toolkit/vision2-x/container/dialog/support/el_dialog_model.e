note
	description: "[
		Dialog style, layout and information for display by dialog conforming to ${EL_MODELED_DIALOG}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "23"

class
	EL_DIALOG_MODEL

inherit
	EL_DIALOG_MODEL_IMPLEMENTATION

	EL_STRING_GENERAL_ROUTINES

	EL_CHARACTER_32_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_title: like title)
		do
			make_default
			title := a_title
		end

	make_default
		do
			title := Empty_string_8; text := Empty_string_8
			icon := Default_icon
			layout := default_layout
			style := default_style

			create progress_meter
			progress_meter.completion_text := Word.complete
			progress_meter.label_text := Word.progress

			default_button_text := Empty_string_8
			cancel_button_text := Empty_string_8
			escape_key_enabled := True
		end

feature -- Text

	cancel_button_text: READABLE_STRING_GENERAL

	default_button_text: READABLE_STRING_GENERAL
		-- button text of dialog `default_button'

	paragraph_list: like new_paragraph_list
		-- paragraphs explictly set with `set_paragraph_list' or else `text' split into paragraphs
		local
			paragraph_split: EL_SPLIT_ZSTRING_LIST
		do
			if attached internal_paragraph_list as list then
				Result := list
			else
				create paragraph_split.make_by_string (as_zstring (text), New_line * 2)
				Result := new_paragraph_list (paragraph_split)
				internal_paragraph_list := Result
			end
		end

	progress_meter: TUPLE [label_text, completion_text: READABLE_STRING_GENERAL]

	text: READABLE_STRING_GENERAL

	title: READABLE_STRING_GENERAL

feature -- Access

	icon: EV_PIXMAP
		-- icon expressing a mood: positive/negative

	layout: EL_DIALOG_LAYOUT

	style: EL_DIALOG_STYLE

feature -- Measurement

	minimum_width_cms: REAL

	paragraph_width (text_list: ITERABLE [READABLE_STRING_GENERAL]): INTEGER
		local
			maximum_width: INTEGER
		do
			maximum_width := Screen.horizontal_pixels (layout.paragraph.width_cms)
			Result := maximum_width.min ((Rendered.widest_width (text_list, style.label_font) * 1.03).rounded)
		end

feature -- Factory

	new_icon_cell: EV_CELL
		do
			-- was this a workaround for Windows? can't remember, but for sure
			-- pixmaps were not being displayed properly unless something preserved the dimensions
			create Result
			Result.set_minimum_size (icon.width, icon.height)
			Result.put (icon)
		end

feature -- Behaviour change

	disable_escape_key
		do
			escape_key_enabled := False
		end

	enable_application
		-- cause application to close when dialog closes
		do
			is_application := True
		end

	enable_cancel_on_focus_out
		-- cause dialog to close if it looses focus by clicking outside area
		do
			cancel_on_focus_out := True
		end

feature -- Closing status

	cancel_on_focus_out: BOOLEAN
		-- when `True' clicking outside the dialog will cancel it

	is_application: BOOLEAN
		-- when `True' causes application to close when destroyed

feature -- Status query

	escape_key_enabled: BOOLEAN
		-- when `True' escape key enabled even when `not has_cancel_button_text'

	has_buttons: BOOLEAN
		do
			Result := has_default_button_text or has_cancel_button_text
		end

	has_cancel_button_text: BOOLEAN
		do
			Result := not cancel_button_text.is_empty
		end

	has_default_button_text: BOOLEAN
		do
			Result := not default_button_text.is_empty
		end

	has_title: BOOLEAN
		do
			Result := title.count > 0
		end

feature -- Set text

	set_cancel_button_text (a_cancel_button_text: READABLE_STRING_GENERAL)
		do
			cancel_button_text := a_cancel_button_text
		end

	set_buttons (a_default_button_text, a_cancel_button_text: READABLE_STRING_GENERAL)
		do
			default_button_text := a_default_button_text
			cancel_button_text := a_cancel_button_text
		end

	set_default_button_text (a_default_button_text: READABLE_STRING_GENERAL)
		do
			default_button_text := a_default_button_text
		end

	set_paragraph_list (list_general: ITERABLE [READABLE_STRING_GENERAL])
		do
			internal_paragraph_list := new_paragraph_list (list_general)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			text := a_text; internal_paragraph_list := Void
		end

	set_title (a_title: like title)
		do
			title := a_title
		end

feature -- Element change

	set_icon (a_icon: like icon)
		do
			icon := a_icon.twin
			icon.set_minimum_size (a_icon.width, a_icon.height)
		end

	set_transparent_icon (a_icon: CAIRO_DRAWING_AREA; width_cms: REAL)
		local
			width: INTEGER
		do
			width := Screen.horizontal_pixels (width_cms)
			icon := a_icon.to_scaled_to_width (width, style.color.content_area).to_pixmap
		end

	set_layout (a_layout: like layout)
		do
			layout := a_layout
		end

	set_minimum_width_cms (a_minimum_width_cms: like minimum_width_cms)
		do
			minimum_width_cms := a_minimum_width_cms
		end

	set_style (a_style: like style)
		do
			style := a_style
		end

feature -- Basic operations

	show_centered_confirmation (parent: EV_WINDOW; action: PROCEDURE)
		local
			dialog: EL_MODELED_CONFIRMATION_DIALOG
		do
			create dialog.make (Current, action)
			dialog.position_center (parent)
			dialog.show_modal_to_window (parent)
		end

	show_centered_information (parent: EV_WINDOW)
		require
			no_default_button: not has_default_button_text
		local
			dialog: EL_MODELED_INFORMATION_DIALOG
		do
			create dialog.make_info (Current)
			dialog.position_center (parent)
			dialog.show_modal_to_window (parent)
		end

invariant
	never_application_and_cancel_on_focus_out: is_application implies not cancel_on_focus_out
end