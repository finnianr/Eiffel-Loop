note
	description: "Passphrase field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 13:25:51 GMT (Sunday 10th November 2024)"
	revision: "9"

class
	EL_PASSPHRASE_FIELD

inherit
	ANY

	EL_WIDGET_REPLACEMENT [EV_TEXT_FIELD]

	EL_MODULE_ACTION

create
	make

feature {NONE} -- Initialization

	make (a_font: EV_FONT)
		do
			font := a_font
			create text.make_empty
			create on_change.make
			item := new_item
		end

feature -- Access

	on_change: EL_EVENT_BROADCASTER

	item: like new_item

	text: ZSTRING

feature -- Element change

	fill_blank
		do
			text.fill_blank
			item.set_text (text.to_unicode)
			if attached mirror as m then
				m.fill_blank
			end
		end

	replace_item
		do
			item := replaced (item, new_item)
		end

	set_mirror (a_mirror: like Current)
		do
			mirror := a_mirror
		end

feature -- Status query

	is_visible: BOOLEAN

	is_confirmed: BOOLEAN
		-- `True' if `text' matches `mirror.text'
		do
			if attached mirror as m then
				Result := text ~ m.text
			end
		end

	is_partially_confirmed: BOOLEAN
		-- `True' if `text' starts with `mirror.text'
		do
			if attached mirror as m then
				Result := text.starts_with (m.text)
			end
		end

feature -- Status change

	disable_for (seconds: REAL)
		do
			item.disable_sensitive
			Action.do_later ((seconds * 1000).rounded, agent item.enable_sensitive)
		end

	set_visibility (visible: BOOLEAN)
		do
			is_visible := visible
			replace_item
			if attached mirror as m then
				m.set_visibility (visible)
				if visible then
					m.item.disable_sensitive
				end
			end
		end

	position_caret
		do
			item.set_focus
			item.deselect_all
			item.set_caret_position (text.count + 1)
		end

feature {NONE} -- Implementation

	new_item: EV_TEXT_FIELD
		do
			if is_visible then
				create Result
			else
				create {EV_PASSWORD_FIELD} Result
			end
			Result.set_font (font)
			Result.set_minimum_width_in_characters (Default_capacity)
			Result.set_text (text.to_unicode)
			Result.change_actions.extend (agent update_text)
			Result.change_actions.extend (agent on_change.notify)
		end

	update_text
		do
			text.wipe_out
			text.append_string_general (item.text)
			if is_visible and then attached mirror as m then
				m.item.set_text (item.text)
			end
		end

feature {NONE} -- Internal attributes

	font: EV_FONT

	mirror: detachable like Current

feature {NONE} -- Constants

	Default_capacity: INTEGER
		once
			Result := 20
		end

end