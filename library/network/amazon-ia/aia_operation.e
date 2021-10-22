note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-18 13:43:32 GMT (Monday 18th October 2021)"
	revision: "7"

class
	AIA_OPERATION

inherit
	ANY

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		local
			name_value: ZSTRING; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			create json_list.make (string)
			json_list.start
			name_value := json_list.value_item (False)
			create name.make (name_value.count)
			Naming.from_camel_case (buffer.copied (name_value), name)
			json_list.forth
		end

feature -- Access

	json_list: EL_JSON_NAME_VALUE_LIST

	name: STRING

end