note
	description: "Dialog style, layout and information for display by dialog conforming to [$source EL_VIEW_DIALOG]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-09 16:07:04 GMT (Thursday 9th June 2022)"
	revision: "13"

class
	EL_DIALOG_MODEL

inherit
	ANY

	EL_MODULE_GUI

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

	EL_MODULE_ITERABLE

	EL_STRING_8_CONSTANTS

	EL_SHARED_WORD

create
	make, make_default

feature {NONE} -- Initialization

	make (a_title: like title)
		do
			title := a_title
			icon := Default_icon
			layout := default_layout
			style := default_style

			create progress_meter
			progress_meter.completion_text := Word.complete
			progress_meter.label_text := Word.progress

			default_button_text := Empty_string_8
			cancel_button_text := Empty_string_8
			escape_key_enabled := True
			text := Empty_string_8
		end

	make_default
		do
			make (Empty_string_8)
		end

feature -- Text

	cancel_button_text: READABLE_STRING_GENERAL

	default_button_text: READABLE_STRING_GENERAL
		-- button text of dialog `default_button'

	paragraph_list: EL_ZSTRING_LIST
		-- paragraphs explictly set with `set_paragraph_list' or else `text' split into paragraphs
		local
			s: EL_ZSTRING_ROUTINES
		do
			if attached internal_paragraph_list as list then
				Result := list
			else
				Result := new_paragraph_list (create {EL_SPLIT_ZSTRING_LIST}.make_by_string (s.as_zstring (text), Paragraph_separator))
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
			Result := maximum_width.min ((GUI.widest_width (text_list, style.label_font) * 1.03).rounded)
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

feature -- Status change

	disable_escape_key
		do
			escape_key_enabled := False
		end

feature -- Status query

	escape_key_enabled: BOOLEAN
		-- `True' is escape key enabled even when `not has_cancel_button_text'

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
			Result := not title.is_empty
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

feature {NONE} -- Implementation

	default_layout: EL_DIALOG_LAYOUT
		do
			create Result.make
		end

	default_style: EL_DIALOG_STYLE
		once
			create Result.make
		end

	new_paragraph_list (list_general: ITERABLE [READABLE_STRING_GENERAL]): like paragraph_list
		local
			lines: EL_ZSTRING_LIST; l_text: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			create Result.make (Iterable.count (list_general))
			across list_general as paragraph loop
				l_text := s.as_zstring (paragraph.item)
				if text.has ('%N') then
					create lines.make_with_lines (l_text)
					Result.extend (lines.joined_words)
				else
					Result.extend (l_text)
				end
			end
		end

feature {NONE} -- Internal attributes

	internal_paragraph_list: detachable EL_ZSTRING_LIST

feature {NONE} -- Constants

	Default_icon: EV_PIXMAP
		once
			Result := Pixmap.Information_pixmap
		end

	Paragraph_separator: ZSTRING
		once
			Result := "%N%N"
		end

end