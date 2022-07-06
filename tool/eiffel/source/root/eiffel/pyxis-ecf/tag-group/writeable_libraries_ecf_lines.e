note
	description: "[$source LIBRARIES_ECF_LINES] for libraries that can be modified in EiffelStudio"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 14:47:29 GMT (Wednesday 6th July 2022)"
	revision: "4"

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