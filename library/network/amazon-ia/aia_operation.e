note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 11:24:58 GMT (Tuesday 5th November 2024)"
	revision: "13"

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
			name_value: ZSTRING
		do
			create json_list.make (string)
			json_list.start
			name_value := json_list.item_value (False)
			create name.make (name_value.count)
			Naming.from_camel_case (Buffer.copied_general (name_value), name)
			json_list.forth
		end

feature -- Access

	json_list: JSON_NAME_VALUE_LIST

	name: STRING

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end