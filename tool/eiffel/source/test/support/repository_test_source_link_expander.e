note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-20 14:20:27 GMT (Monday 20th June 2022)"
	revision: "7"

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