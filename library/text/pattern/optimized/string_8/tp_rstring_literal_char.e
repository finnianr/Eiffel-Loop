note
	description: "Matches single literal character in a string conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	TP_RSTRING_LITERAL_CHAR

inherit
	TP_LITERAL_CHAR
		redefine
			make, i_th_matches
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

create
	make, make_with_action

feature {NONE} -- Initialization

	make (uc: CHARACTER_32)
			--
		do
			Precursor (uc)
			if uc.is_character_8 then
				item_8 := uc.to_character_8
			end
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i] = item_8
		end

feature -- Access

	item_8: CHARACTER_8

end