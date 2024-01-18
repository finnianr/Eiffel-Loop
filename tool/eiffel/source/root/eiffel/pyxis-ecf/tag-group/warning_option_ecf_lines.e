note
	description: "${GROUPED_ECF_LINES} for **setting** tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

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