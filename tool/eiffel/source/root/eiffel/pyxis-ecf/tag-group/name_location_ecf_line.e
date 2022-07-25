note
	description: "[$source NAME_VALUE_ECF_LINE] for **name location** attribute pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 6:03:58 GMT (Monday 25th July 2022)"
	revision: "5"

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