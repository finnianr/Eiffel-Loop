note
	description: "Repository test source link expander"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 13:03:44 GMT (Thursday 13th January 2022)"
	revision: "5"

class
	REPOSITORY_TEST_SOURCE_LINK_EXPANDER

inherit
	REPOSITORY_SOURCE_LINK_EXPANDER
		undefine
			make_default, new_medium
		end

	REPOSITORY_TEST_PUBLISHER
		rename
			make as make_publisher
		undefine
			description, execute, ok_to_synchronize
		end

create
	make

end