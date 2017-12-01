note
	description: "Summary description for {EL_REFLECTIVELY_JSON_SETTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-28 11:39:25 GMT (Tuesday 28th November 2017)"
	revision: "1"

deferred class
	EL_REFLECTIVELY_JSON_SETTABLE

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]

	EL_JSON_ROUTINES

feature -- Access

	to_string: STRING
		do
		end

feature -- Element change

	set_from_json (json_list: EL_JSON_NAME_VALUE_LIST)
		local
			table: like field_index_table
			object: like current_object
		do
			object := current_object
			table := field_index_table
			if json_list.off then
				json_list.start
			end
			from  until json_list.after loop
				table.search (json_list.name_item_8)
				if table.found then
					set_object_field (object, table.found_item, json_list.value_item)
				end
				json_list.forth
			end
		end
end
