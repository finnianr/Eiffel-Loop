note
	description: "[
		Parse name value pair with syntax

			<name> = <value>

		**OR**

			<name> = "<value>"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-02 11:01:33 GMT (Wednesday 2nd February 2022)"
	revision: "1"

expanded class
	EL_ASSIGNMENT_ROUTINES

inherit
	EL_NAME_VALUE_PAIR_ROUTINES

	EL_EXPANDED_ROUTINES

feature {NONE} -- Constants

	Delimiter: CHARACTER_32 = '='
end