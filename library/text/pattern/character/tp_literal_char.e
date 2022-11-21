note
	description: "Matches single literal character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:54 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_LITERAL_CHAR

inherit
	TP_CHARACTER_PROPERTY

create
	make, make_with_action

feature {NONE} -- Initialization

	make (uc: CHARACTER_32)
			--
		do
			item := uc
		end

	make_with_action (a_item: like item; a_action: like Default_action)
			--
		do
			make (a_item); set_action (a_action)
		end

feature -- Access

	item: CHARACTER_32

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i] = item
		end

	name_inserts: TUPLE
		do
			Result := [item]
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "'%S'"
		end
end
