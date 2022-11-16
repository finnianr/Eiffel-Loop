note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

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
			Naming.from_camel_case (buffer.copied (name_value.to_latin_1), name)
			json_list.forth
		end

feature -- Access

	json_list: JSON_NAME_VALUE_LIST

	name: STRING

end