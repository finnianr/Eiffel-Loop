note
	description: "${EL_NAME_VALUE_PAIR [STRING_8]} with possibility of `/=' indicating an **excluded_value**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-30 12:08:39 GMT (Friday 30th August 2024)"
	revision: "6"

class
	ECF_NAME_VALUE_PAIR

inherit
	EL_NAME_VALUE_PAIR [STRING]
		rename
			make as make_name_value
		end

create
	make, make_empty, make_pair

feature {NONE} -- Initialization

	make (str: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			make_name_value (str, '=')
			if s.ends_with_character (name, '/') then
				is_excluded_value := True
				name.remove_tail (1)
				name.right_adjust
			end
		end

feature -- Status query

	is_excluded_value: BOOLEAN

end