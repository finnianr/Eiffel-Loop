note
	description: "[$source NAME_VALUE_ECF_LINE] for **old_name new_name** renaming attribute pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-08 10:33:44 GMT (Friday 8th July 2022)"
	revision: "3"

class
	OLD_NAME_NEW_NAME_ECF_LINE

inherit
	NAME_VALUE_ECF_LINE
		redefine
			Template
		end

create
	make

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				old_name = $NAME; new_name = $VALUE
			]"
		end
end