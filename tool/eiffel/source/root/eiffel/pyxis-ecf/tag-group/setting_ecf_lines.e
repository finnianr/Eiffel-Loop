note
	description: "${GROUPED_ECF_LINES} for **setting** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	SETTING_ECF_LINES

inherit
	GROUPED_ECF_LINES

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.setting
		end

end