note
	description: "[
		A list of strings each associated with a text style defined by class ${EL_TEXT_STYLE}.

			feature -- Styles

				Regular: INTEGER = 1

				Bold: INTEGER = 2

				Monospaced: INTEGER = 3

				Monospaced_bold: INTEGER = 4

		When rendered the strings are usually joined together first separated by a space character.
		It is up to the rendering class what font to use for the text style. See
		${EL_HYPERLINK_AREA} for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

deferred class
	EL_STYLED_TEXT_LIST [S -> STRING_GENERAL]

inherit
	EL_ARRAYED_MAP_LIST [INTEGER, S]
		rename
			first_key as first_style,
			first_value as first_text,
			item_key as item_style,
			item_value as item_text,
			last_key as last_style,
			last_value as last_text,
			extend as extend_list,
			put_front as put_front_list
		end

	EL_TEXT_STYLE
		export
			{NONE} all
			{ANY} is_valid_style
		undefine
			copy, is_equal
		end

	EL_SHARED_FILLED_STRING_TABLES

feature {NONE} -- Initialization

	make_regular (text: READABLE_STRING_GENERAL)
		do
			make (1)
			extend (Regular, new_text (text))
		end

feature -- Transformation

	indent_first
		-- indent first string in list by one space
		do
			if count > 0 then
				put_i_th_value (n_character_string (' ', 1) + first_text, 1)
			end
		end

	trim_last_word
		-- Recursively remove the last word from `last_text' and append the `ellipsis' string
		-- if not already present
		local
			space_pos: INTEGER
		do
			if count > 0 and then attached last_text as text then
				if text ~ ellipsis then
					remove_tail (1); trim_last_word -- Recurse

				elseif count > 0 then
					space_pos := text.last_index_of (' ', text.count)
					if space_pos > 0 then
						set_last_value (text.substring (1, space_pos) + ellipsis)
					else
						set_last_value (ellipsis)
					end
				end
			end
		end

feature -- Element change

	extend (style: like item_style; text: READABLE_STRING_GENERAL)
		require
			valid_style: is_valid_style (style)
		do
			extend_list (style, new_text (text))
		end

	put_front (style: like item_style; text: READABLE_STRING_GENERAL)
		require
			valid_style: is_valid_style (style)
		do
			put_front_list (style, new_text (text))
		end

feature {NONE} -- Implementation

	ellipsis: S
		do
			Result := n_character_string ('.', 2)
		end

	n_character_string (c: CHARACTER; n: INTEGER): S
		deferred
		end

	new_text (text: READABLE_STRING_GENERAL): S
		deferred
		end

end