note
	description: "Default filter condition for class [$source EL_FIND_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-16 10:36:46 GMT (Saturday 16th May 2020)"
	revision: "1"

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
