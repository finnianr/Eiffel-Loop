note
	description: "[$source GROUPED_ECF_LINES] for **setting** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 14:46:03 GMT (Wednesday 6th July 2022)"
	revision: "1"

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