note
	description: "Styled zstring list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-02 10:41:37 GMT (Wednesday 2nd September 2020)"
	revision: "1"

class
	EL_STYLED_ZSTRING_LIST

inherit
	EL_STYLED_TEXT_LIST [ZSTRING]

	EL_ZSTRING_CONSTANTS

create
	make, make_filled, make_from_list, make_empty, make_from_array, make_regular

convert
	make_regular ({ZSTRING})

feature -- Element change

	indent_first
		do
			if count > 0 then
				first.value := character_string (' ') + first_text
			end
		end

	trim_last_word
		-- Remove last word from `last_text' and append an ellipsis ".."
		local
			space_pos: INTEGER; text: ZSTRING
		do
			if count > 0 then
				text := last_text
				if text ~ Ellipsis then
					remove_tail (1); trim_last_word -- Recurse
				else
					space_pos := text.last_index_of (' ', text.count)
					if space_pos > 0 then
						last.value := text.substring (1, space_pos) + Ellipsis
					else
						last.value := Ellipsis
					end
				end
			end
		end

feature -- Constants

	Ellipsis: ZSTRING
		once
			Result := n_character_string ('.', 2)
		end
end
