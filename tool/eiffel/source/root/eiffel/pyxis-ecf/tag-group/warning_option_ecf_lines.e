note
	description: "[$source GROUPED_ECF_LINES] for **setting** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 13:17:38 GMT (Wednesday 6th July 2022)"
	revision: "1"

class
	WARNING_OPTION_ECF_LINES

inherit
	OPTION_ECF_LINES

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.warning
		end
end