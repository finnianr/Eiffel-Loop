note
	description: "Matches single literal character in a string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:20:35 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_STRING_8_LITERAL_CHAR_TP

inherit
	EL_LITERAL_CHAR_TP
		redefine
			make, i_th_matches
		end

	EL_SHARED_ZSTRING_CODEC

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