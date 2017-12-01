note
	description: "Summary description for {AIA_OPERATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-28 11:36:15 GMT (Tuesday 28th November 2017)"
	revision: "1"

class
	AIA_OPERATION

inherit
	EL_ATTRIBUTE_NAME_ROUTINES

	EL_SHARED_ONCE_STRINGS

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		local
			l_name: STRING
		do
			l_name := empty_once_string_8
			create json_list.make (string)
			json_list.start
			from_camel_case (json_list.value_item_8, l_name)
			name := l_name
			json_list.forth
		end

feature -- Access

	json_list: EL_JSON_NAME_VALUE_LIST

	name: ZSTRING

end
