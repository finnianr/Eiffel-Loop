note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
		undefine
			make_default, new_medium
		redefine
			user_response
		end

	REPOSITORY_TEST_PUBLISHER
		rename
			make as make_publisher
		undefine
			execute, ok_to_synchronize
		end

create
	make

feature {NONE} -- Implementation

	user_response: STRING
		do
			Result := Quit
		end

end