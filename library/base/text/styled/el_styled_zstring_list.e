note
	description: "Styled zstring list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 18:18:10 GMT (Friday 8th January 2021)"
	revision: "2"

class
	EL_STYLED_ZSTRING_LIST

inherit
	EL_STYLED_TEXT_LIST [ZSTRING]

create
	make, make_filled, make_from_list, make_empty, make_from_array, make_regular

convert
	make_regular ({ZSTRING})

feature -- Element change

	indent_first
		local
			s: EL_ZSTRING_ROUTINES
		do
			if count > 0 then
				first.value := s.character_string (' ') + first_text
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
		local
			s: EL_ZSTRING_ROUTINES
		once
			Result := s.n_character_string ('.', 2)
		end
end