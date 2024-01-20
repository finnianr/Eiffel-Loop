note
	description: "Default filter condition for class ${EL_FIND_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_ANY_FILE_FIND_CONDITION

inherit
	EL_FIND_FILE_CONDITION

feature {NONE} -- Status query

	met (path: ZSTRING): BOOLEAN
		do
			Result := True
		end
end