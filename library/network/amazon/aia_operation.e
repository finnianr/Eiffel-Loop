note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-15 21:12:49 GMT (Friday 15th December 2017)"
	revision: "3"

class
	AIA_OPERATION

inherit
	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		do
			create json_list.make (string)
			json_list.start
			create name.make (json_list.value_item_8.count)
			Naming.from_camel_case (json_list.value_item_8, name)
			json_list.forth
		end

feature -- Access

	json_list: EL_JSON_NAME_VALUE_LIST

	name: STRING

end
