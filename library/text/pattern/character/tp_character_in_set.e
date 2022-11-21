note
	description: "Matches character found in specified set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:55 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_CHARACTER_IN_SET

inherit
	TP_CHARACTER_PROPERTY
		rename
			i_th_matches as i_th_in_set
		end

create
	make

feature {NONE} -- Initialization

	make (a_character_set: READABLE_STRING_GENERAL)
		do
			create set.make_from_general (a_character_set)
		end

feature {NONE} -- Implementation

	i_th_in_set (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if i'th character is in `set'
		do
			Result := set.has (text [i])
		end

	name_inserts: TUPLE
		do
			Result := [set.to_latin_1]
		end

feature {NONE} -- Internal attributes

	set: ZSTRING

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "in set: {%S}"
		end
end
