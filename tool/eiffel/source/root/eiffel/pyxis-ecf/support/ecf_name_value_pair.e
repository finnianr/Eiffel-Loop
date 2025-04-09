note
	description: "${EL_NAME_VALUE_PAIR [STRING_8]} with possibility of `/=' indicating an **excluded_value**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 19:17:13 GMT (Tuesday 8th April 2025)"
	revision: "7"

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
			sg: EL_STRING_GENERAL_ROUTINES
		do
			make_name_value (str, '=')
			if sg.super_8 (name).ends_with_character ('/') then
				is_excluded_value := True
				name.remove_tail (1)
				name.right_adjust
			end
		end

feature -- Status query

	is_excluded_value: BOOLEAN

end