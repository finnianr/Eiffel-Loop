note
	description: "${LIBRARIES_ECF_LINES} for libraries that can be modified in EiffelStudio"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	WRITEABLE_LIBRARIES_ECF_LINES

inherit
	LIBRARIES_ECF_LINES
		redefine
			Template
		end

create
	make

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; location = $VALUE; readonly = false
			]"
		end

end