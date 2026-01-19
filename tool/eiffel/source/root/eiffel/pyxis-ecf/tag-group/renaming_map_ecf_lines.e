note
	description: "[
		${GROUPED_ECF_LINES} **renaming_map** element followed by class name 
		
			renaming_map:
				OLD_NAME = NEW_NAME
				OLD_NAME_2 = NEW_NAME_2
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	RENAMING_MAP_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			Template
		end

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.renaming
		end

feature {NONE} -- Constants

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					old_name = $NAME; new_name = $VALUE
			]"
		end
end