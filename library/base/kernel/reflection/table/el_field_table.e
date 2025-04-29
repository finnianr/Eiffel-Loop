note
	description: "Reflected field table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 11:04:15 GMT (Tuesday 29th April 2025)"
	revision: "40"

class
	EL_FIELD_TABLE

inherit
	EL_IMMUTABLE_KEY_8_TABLE [EL_REFLECTED_FIELD]
		rename
			make as make_sized,
			make_equal as make,
			current_keys as name_list
		export
			{EL_EXPORT_FIELD_TABLE} all
			{ANY} after, count, item, name_list, extend, found, found_item, forth,
					has_general, has_key_general, has_immutable_key, has_immutable, has, has_key,
					item_list, item_for_iteration, key_for_iteration, search, start
		end

create
	make

end