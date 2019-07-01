note
	description: "[
		Parses the JSON from an Instant Access request and stores the operation name
		accessible as `name'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-07 14:02:58 GMT (Saturday 7th April 2018)"
	revision: "4"

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
			create name.make (json_list.value_item.count)
			Naming.from_camel_case (json_list.value_item, name)
			json_list.forth
		end

feature -- Access

	json_list: EL_JSON_NAME_VALUE_LIST

	name: STRING

end
