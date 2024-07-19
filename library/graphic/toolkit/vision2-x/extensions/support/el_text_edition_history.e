note
	description: "[
		Text edition history for text editing component conforming to ${EL_UNDOABLE_TEXT_COMPONENT_I}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-19 9:59:45 GMT (Friday 19th July 2024)"
	revision: "2"

class
	EL_TEXT_EDITION_HISTORY

inherit
	EL_ZSTRING_EDITION_HISTORY
		rename
			make as make_size
		redefine
			insert_character, insert_string, remove_character, replace_character, replace_substring,
			remove_substring, set_full_string
		end

	EL_MODULE_TEXT

	EL_CHARACTER_32_CONSTANTS; EL_STRING_8_CONSTANTS

create
	make

feature -- Initialization

	make (a_target: like target; n: INTEGER)
		do
			make_size (n)
			target := a_target
		end

feature {NONE} -- Edition operations

	insert_character (c: CHARACTER_32; start_index: INTEGER)
		do
			Precursor (c, start_index)
			if not checking_valid then
				Text.set_clipboard (char (c))
				target.paste (start_index)
			end
		end

	insert_string (str: ZSTRING; start_index: INTEGER)
		do
			Precursor (str, start_index)
			if not checking_valid then
				Text.set_clipboard (str)
				target.paste (start_index)
			end
		end

	remove_character (start_index: INTEGER)
		do
			Precursor (start_index)
			if not checking_valid then
				target.select_region (start_index, start_index)
				target.delete_selection
			end
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			Precursor (start_index, end_index)
			if not checking_valid then
				target.select_region (start_index, end_index)
				target.delete_selection
			end
		end

	replace_character (c: CHARACTER_32; start_index: INTEGER)
		do
			Precursor (c, start_index)
			if not checking_valid then
				target.select_region (start_index, start_index)
				target.delete_selection
				Text.set_clipboard (char (c))
				target.paste (start_index)
			end
		end

	replace_substring (str: ZSTRING; start_index, end_index: INTEGER)
		do
			Precursor (str, start_index, end_index)
			if not checking_valid then
				target.select_region (start_index, end_index)
				target.delete_selection
				Text.set_clipboard (str)
				target.paste (start_index)
			end
		end

	set_full_string (str: ZSTRING)
		do
			Precursor (str)
			if not checking_valid then
				target.set_text (Empty_string_8)
				Text.set_clipboard (str)
				target.paste (1)
			end
		end

feature {NONE} -- Internal attributes

	target: EL_UNDOABLE_TEXT_COMPONENT_I
end