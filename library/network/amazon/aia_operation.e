note
	description: "Summary description for {AIA_OPERATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-05 17:14:12 GMT (Tuesday 5th December 2017)"
	revision: "2"

class
	AIA_OPERATION

inherit
	EL_ATTRIBUTE_NAME_TRANSLATEABLE

create
	make

feature {NONE} -- Initialization

	make (string: STRING)
		do
			create json_list.make (string)
			json_list.start
			create name.make (json_list.value_item_8.count)
			from_camel_case (json_list.value_item_8, name)
			json_list.forth
		end

feature -- Access

	json_list: EL_JSON_NAME_VALUE_LIST

	name: STRING

end
