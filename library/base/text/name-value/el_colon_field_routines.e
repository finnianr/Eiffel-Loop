note
	description: "[
		Parse name value pair with syntax
		
			<name>: <value>
			
		**OR**
		
			<name>: "<value>"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-02 10:52:45 GMT (Wednesday 2nd February 2022)"
	revision: "9"

expanded class
	EL_COLON_FIELD_ROUTINES

inherit
	EL_NAME_VALUE_PAIR_ROUTINES

	EL_EXPANDED_ROUTINES

feature {NONE} -- Constants

	Delimiter: CHARACTER_32 = ':'
end