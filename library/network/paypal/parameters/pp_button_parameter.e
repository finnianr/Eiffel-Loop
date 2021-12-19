note
	description: "Button parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 14:00:54 GMT (Sunday 19th December 2021)"
	revision: "4"

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

	make (field_name: STRING)
		-- use last part as value, remainder as name
		local
			parts: EL_SPLIT_STRING_LIST [STRING]
		do
			create parts.make (field_name, '_')
			parts.finish
			value := parts.item
			value.to_upper
			parts.remove
			name := parts.joined_strings
			name.to_upper
		end

end