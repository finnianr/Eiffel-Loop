note
	description: "Matches character found in specified set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 16:35:23 GMT (Monday 31st October 2022)"
	revision: "1"

class
	EL_MATCH_CHARACTER_IN_SET_TP

inherit
	EL_CHARACTER_PROPERTY_TP
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

feature -- Access

	name: STRING
		do
			Result := "in set: {}"
			Result.insert_string (set.to_latin_1, Result.count)
		end

feature {NONE} -- Implementation

	i_th_in_set (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if i'th character is in `set'
		do
			Result := set.has (text [i])
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- contract support
		do
			Result := set.has (text [a_offset + 1])
		end

feature {NONE} -- Internal attributes

	set: ZSTRING

end