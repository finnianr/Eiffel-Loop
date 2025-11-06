note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-06 7:19:01 GMT (Thursday 6th November 2025)"
	revision: "14"

class
	AIA_OPERATION

inherit
	ANY

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		do
			create json_list.make (string)
			json_list.start
			if attached json_list.item_immutable_value as name_value then
				create name.make (name_value.count)
				Naming.from_camel_case (name_value, name)
			else
				create name.make_empty
			end
			json_list.forth
		end

feature -- Access

	json_list: JSON_NAME_VALUE_LIST

	name: STRING

end