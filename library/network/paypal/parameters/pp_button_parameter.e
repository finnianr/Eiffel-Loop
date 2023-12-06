note
	description: "Button parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 9:12:22 GMT (Wednesday 6th December 2023)"
	revision: "9"

class
	PP_BUTTON_PARAMETER

inherit
	EL_HTTP_NAME_VALUE_PARAMETER
		rename
			make as make_parameter
		end

create
	make

feature {NONE} -- Initialization

	make (field_name: IMMUTABLE_STRING_8)
		-- use last part as value, remainder as name
		-- button_code_hosted => BUTTONCODE=HOSTED
		require
			has_underscore: field_name.has ('_')
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
			l_count, last_index: INTEGER
		do
			l_count := field_name.count
			last_index := field_name.last_index_of ('_', l_count)
			create name.make (last_index - 1)
			create value.make (l_count - last_index)
			create split_list.make (field_name, '_')
			across split_list as list loop
				if list.is_last then
					value.append_string_general (list.item)
				else
					name.append_string_general (list.item)
				end
			end
			value.to_upper; name.to_upper
		end

end