note
	description: "${NAME_VALUE_ECF_LINE} for **name location** attribute pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	NAME_LOCATION_ECF_LINE

inherit
	NAME_VALUE_ECF_LINE
		redefine
			Reserved_name_set, Template
		end

create
	make

feature {NONE} -- Constants

	Reserved_name_set: ARRAY [STRING]
		once
			Result := << Name.name, Name.location >>
		end

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				name = $NAME; location = $VALUE
			]"
		end
end