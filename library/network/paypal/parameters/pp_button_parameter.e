note
	description: "Button parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 11:09:34 GMT (Saturday 28th April 2018)"
	revision: "1"

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
			l_name: STRING
		do
			create parts.make (field_name, once "_")
			parts.finish
			value := parts.item
			value.to_upper
			parts.remove
			name := parts.joined_strings
			name.to_upper
		end

end
