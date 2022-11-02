note
	description: "Matches single literal character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 7:54:50 GMT (Wednesday 2nd November 2022)"
	revision: "3"

class
	EL_LITERAL_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP

create
	make, make_with_action

feature {NONE} -- Initialization

	make (uc: CHARACTER_32)
			--
		do
			make_default
			item := uc
		end

	make_with_action (a_item: like item; a_action: like actions.item)
			--
		do
			make (a_item); set_action (a_action)
		end

feature -- Access

	name: STRING
		do
			create Result.make (3)
			Result.append_character ('%'')
			if item <= '%/127/' then
				Result.append_character (item.to_character_8)
			else
				Result.append_character ('?')
			end
			Result.append_character ('%'')
		end

	item: CHARACTER_32

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i] = item
		end

end