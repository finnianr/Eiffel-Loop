note
	description: "[
		Parse name value pair with syntax

			<name> = <value>

		**OR**

			<name> = "<value>"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

expanded class
	EL_ASSIGNMENT_ROUTINES

inherit
	EL_NAME_VALUE_PAIR_ROUTINES

	EL_EXPANDED_ROUTINES

feature {NONE} -- Constants

	Delimiter: CHARACTER_32 = '='
end