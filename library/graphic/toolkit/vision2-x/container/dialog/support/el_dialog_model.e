note
	description: "Dialog style, layout and information for display by dialog conforming to [$source EL_VIEW_DIALOG]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 15:39:54 GMT (Friday 14th August 2020)"
	revision: "2"

class
	EL_DIALOG_MODEL

inherit
	EL_DIALOG_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_GUI

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

	EL_MODULE_ZSTRING

	EL_MODULE_ITERABLE

	EL_STRING_8_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_title: like title)
		do
			title := a_title
			icon := Default_icon
			layout := Default_layout
			style := Default_style
			paragraph_list := Default_paragraph_list
			english := [Empty_string_8, Empty_string_8]
			escape_key_enabled := True
		end

	make_default
		do
			make (Empty_string_8)
		end

feature -- Access

	cancel_button_text: READABLE_STRING_GENERAL
		do
			if has_cancel_button_text then
				Result := Locale * english.cancel_button
			else
				Result := Empty_string_8
			end
		end

	default_button_text: READABLE_STRING_GENERAL
		-- button text of dialog `default_button'
		do
			if has_default_button_text then
				Result := Locale * english.default_button
			else
				Result := Empty_string_8
			end
		end

	icon: EV_PIXMAP
		-- icon expressing a mood: positive/negative

	layout: EL_DIALOG_LAYOUT

	paragraph_list: EL_ZSTRING_LIST

	style: EL_DIALOG_STYLE

	title: READABLE_STRING_GENERAL

feature -- Measurement

	minimum_width_cms: REAL

	paragraph_width: INTEGER
		do
			Result := (GUI.widest_width (paragraph_list, style.label_font) * 1.03).rounded
			Result := Result.min (Screen.horizontal_pixels (layout.paragraph.width_cms))
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
			Result := english.cancel_button /= Empty_string_8
		end

	has_default_button_text: BOOLEAN
		do
			Result := english.default_button /= Empty_string_8
		end

	has_title: BOOLEAN
		do
			Result := not title.is_empty
		end

feature -- Element change

	set_buttons_english (a_default, a_cancel: STRING)
		do
			english := [a_default, a_cancel]
		end

	set_cancel_button_english (en_text: STRING)
		do
			english.put_reference (en_text, 2)
		end

	set_default_button_english (en_text: STRING)
		do
			english.put_reference (en_text, 1)
		end

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

	set_paragraph_list (list: ITERABLE [READABLE_STRING_GENERAL])
		local
			lines: EL_ZSTRING_LIST; text: ZSTRING
		do
			create paragraph_list.make (Iterable.count (list))
			across list as paragraph loop
				text := Zstring.to (paragraph.item)
				if text.has ('%N') then
					create lines.make_with_lines (text)
					paragraph_list.extend (lines.joined_words)
				else
					paragraph_list.extend (text)
				end
			end
		end

	set_paragraphs (string: READABLE_STRING_GENERAL)
		do
			set_paragraph_list (create {EL_SPLIT_ZSTRING_LIST}.make (Zstring.to (string), Paragraph_separator))
		end

	set_style (a_style: like style)
		do
			style := a_style
		end

	set_title (a_title: like title)
		do
			title := a_title
		end

feature -- Basic operations

	show_centered_information (parent: EV_WINDOW)
		require
			no_default_button: not has_default_button_text
		local
			dialog: EL_INFORMATION_VIEW_DIALOG
		do
			create dialog.make_info (Current)
			if attached {EL_POSITIONABLE} parent as p then
				dialog.position_center (p)
			end
			dialog.show_modal_to_window (parent)
		end

	show_centered_confirmation (parent: EV_WINDOW; action: PROCEDURE)
		local
			dialog: EL_CONFIRMATION_VIEW_DIALOG
		do
			create dialog.make (Current, action)
			if attached {EL_POSITIONABLE} parent as p then
				dialog.position_center (p)
			end
			dialog.show_modal_to_window (parent)
		end

feature {NONE} -- Internal attributes

	english: TUPLE [default_button, cancel_button: STRING]

feature {NONE} -- Constants

	Default_icon: EV_PIXMAP
		once
			Result := Pixmap.Information_pixmap
		end

	Default_layout: EL_DIALOG_LAYOUT
		once
			create Result.make
		end

	Default_paragraph_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Default_style: EL_DIALOG_STYLE
		once
			create Result.make
		end

	Paragraph_separator: ZSTRING
		once
			Result := "%N%N"
		end

end
