note
	description: "Button parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 10:29:17 GMT (Monday 7th August 2023)"
	revision: "7"

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
		do
			name := field_name
			value := name.substring_to_reversed ('_', default_pointer)
			value.to_upper

			name.remove_tail (value.count + 1)
			name.to_upper
		ensure
			reversible: field_name.as_upper ~ (name + "_" + value).to_latin_1
		end

end