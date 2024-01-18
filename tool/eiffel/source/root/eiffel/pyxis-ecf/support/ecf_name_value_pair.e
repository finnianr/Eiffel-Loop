note
	description: "${EL_NAME_VALUE_PAIR [STRING]} with possibility of `/=' indicating an **excluded_value**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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
			index: INTEGER
		do
			set_from_string (str, '=')
			if attached name then
				index := str.index_of ('/', 1)
				if index > 0 and then index < str.count and then str [index + 1] = '=' then
					is_excluded_value := True
					name.remove_tail (1)
					name.left_adjust
				end
			else
				make_empty
			end
		end

feature -- Status query

	is_excluded_value: BOOLEAN

end