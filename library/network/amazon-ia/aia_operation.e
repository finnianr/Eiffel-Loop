note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-11 14:09:20 GMT (Saturday 11th November 2023)"
	revision: "12"

class
	AIA_OPERATION

inherit
	ANY

	EL_MODULE_NAMING

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		local
			name_value: ZSTRING
		do
			create json_list.make (string)
			json_list.start
			name_value := json_list.item_value (False)
			create name.make (name_value.count)
			across String_8_scope as scope loop
				Naming.from_camel_case (scope.copied_item (name_value), name)
			end
			json_list.forth
		end

feature -- Access

	json_list: JSON_NAME_VALUE_LIST

	name: STRING

end