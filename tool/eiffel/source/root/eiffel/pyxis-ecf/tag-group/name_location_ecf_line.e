note
	description: "[$source GROUPED_ECF_LINES] **name location** attribute pair line"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 16:28:50 GMT (Wednesday 6th July 2022)"
	revision: "2"

class
	NAME_LOCATION_ECF_LINE

inherit
	NAME_VALUE_ECF_LINE
		redefine
			Template
		end

create
	make

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				name = $NAME; location = $VALUE
			]"
		end
end